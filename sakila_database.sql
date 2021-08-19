/*Query 1*/
WITH t1 AS (SELECT *
            FROM category c
            JOIN film_category fc
            ON c.category_id = fc.category_id
            JOIN film f
            ON f.film_id = fc.film_id
            JOIN inventory i
            ON i.film_id = f.film_id
            JOIN rental r
            ON r.inventory_id = i.inventory_id
            WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family','Music')),

    t2 AS (SELECT t1.title film_title, t1.name category_name, COUNT(t1.title) rental_count
    FROM t1
    GROUP BY 1, 2
    ORDER BY category_name, film_title)


SELECT DISTINCT t1.name category_name,
      SUM(t2.rental_count) OVER (PARTITION BY t1.name ORDER BY t1.name) AS sum_rental
FROM t1
JOIN t2
ON t1.title = t2.film_title
GROUP BY 1, t2.rental_count, film_title
ORDER BY 2 DESC;



/*Query 2*/
WITH t1 AS (SELECT *, COUNT(*) counts
            FROM category c
            JOIN film_category fc
            ON c.category_id = fc.category_id
            JOIN film f
            ON f.film_id = fc.film_id
            WHERE c.name IN ('Animation', 'Children','Classics','Comedy','Family','Music')
            GROUP BY c.category_id, fc.film_id, fc.category_id, f.film_id)

SELECT t1.title, t1.name, t1.rental_duration,
      NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
FROM t1
ORDER BY standard_quartile;



/*Query 3*/
WITH t1 AS (SELECT c.name category,
            NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
WHERE c.name IN ('Animation', 'Children','Classics','Comedy','Family','Music')
ORDER BY category, standard_quartile)

SELECT t1.category, t1.standard_quartile, COUNT(*)
FROM t1
GROUP BY 1,2
ORDER BY category, standard_quartile;



/*Query 4*/
WITH t1 AS (SELECT DATE_PART('month', r.rental_date) rental_month,
            DATE_PART('year', r.rental_date) rental_year,
            s.store_id store_id,
            r.rental_id rental_id
            FROM store s
            JOIN staff st
            ON s.store_id = st.store_id
            JOIN rental r
            ON r.staff_id = st.staff_id)

SELECT t1.rental_month, t1.rental_year, t1.store_id, COUNT(*) count_rentals
FROM t1
GROUP BY 1,2,3
ORDER BY 4 DESC;