package com.example.bookStore.repository;

import com.example.bookStore.entity.MyBookList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MyBookRepository extends JpaRepository<MyBookList,Integer> {

}
