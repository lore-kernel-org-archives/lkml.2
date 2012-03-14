Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587Ab2CNOA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:00:59 -0400
Received: from nm29-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.166]:47433 "HELO
	nm29-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752638Ab2CNOA4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:00:56 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 10:00:55 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 156174.62628.bm@omp1005.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VFFono7ngozaOGME212J+1QnIap1WdedQHUjyy3RqnJmr+gnQ/cN3iIF9bBb5iX1sHMyO9XIsBQ/csTYVcl3w/LTxjLi5pyiWBiUDcc5h9bdImMTE2PjoRHzBYxnjseJBtVJEJ3x2w5dYaD/vhrPHnfiewjq2dTbjkVWkLtV6Po=;
X-YMail-OSG: tAV3NJwVM1lADk0.5hUsR8OcvH21qQbjORxk6QrMAipcq40
 wwICiDC4LHc.KSq2FoEUN3Taixj51fuQ_byQq2GCZtOzLREtqw5m5oi8H.Ws
 upSFP8qygJ0ioQfTrPZEcGDkcGu9HOtSyL1MBwotzNwHno7JXDew65qi7DL_
 42vYwLmgKBmROuGXd8ansEiFGiTYGS4rGYoIKVSFxlrz0To3K0Xs.cs.a6WG
 P8uD7n7oHWVUoJEygiiwlA_J3XEYbik6qIXyPGL7_9xu00v.JjgANnzoRZR_
 mXaIu8rZSw_g317MRX136vpba5O86gjX2HotmzrKkDU2dLkQP1jWjR3XG0Yn
 21GDardCm83USljCpK7R7Uv28IP0Uo9nnt1mbNDvSet3sTwjKVf1XAYxhm5o
 y6o9O0nHEKhlQJD.R.JfCKy5Sn4TLizqS67ZEsYlR_1mRHLEAXV7RSsxvW2C
 JFOHaXeckHapgFEiavO9K2VpOjS3CBYM-
X-Mailer: YahooMailWebService/0.8.116.338427
Message-ID: <1331733335.28753.YahooMailNeo@web162004.mail.bf1.yahoo.com>
Date: Wed, 14 Mar 2012 06:55:35 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: [HELP]: How to use ION memory manager from user space ?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,
 
I need a sample user space program that uses ION memory manager to allocate memory.

That is to use /dev/ion and use ION ioctl calls to allocate and share memory from user space.
 
I enabled ION memory manager in kernel but I could not find any test program to test ION.
 
If anybody knows about any test program/utility for testing ION manager. Please let me know.
 
 
Thanks,
Pintu
