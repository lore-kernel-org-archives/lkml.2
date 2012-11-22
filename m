Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2KVTCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:02:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26844 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2KVTCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:02:31 -0500
X-AuditID: cbfee61b-b7f616d00000319b-4a-50adaf3f4647
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com, kyungmin.park@samsung.com,
        sachin.kamat@linaro.org, khoroshilov@ispras.ru
Subject: [GIT PULL] extcon for Linux 3.8
Date: Thu, 22 Nov 2012 13:51:10 +0900
Message-id: <1353559870-23394-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-reply-to: <20121121143553.GB21654@kroah.com>
References: <20121121143553.GB21654@kroah.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zXV379WsDDG5uY7O4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ/89MYSq4J1gxcfoypgbGf3xdjJwcEgImEj/XH2eCsMUkLtxb
	z9bFyMUhJLCMUeLZjw/sXYwcYEVPFiZCxKczSnyZ3cIK4Sxlklh2+iwzSDebgK7E1g13WUBs
	EQE5iSe3/zCDFDELzGOUmPLoHDtIQlhAQ2LH9ztgRSwCqhL71k9iBbF5BTwk/q29zwZxhoLE
	ryOrwOKcAvoSnz+3gS0QEtCTOLv+KBNEr4DEt8mHWCCuk5XYdIAZovU6m8S8uakQtqTEwRU3
	WCYwCi9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERKC0jsYVzVYHGIU4GBU4uHNMFgb
	IMSaWFZcmXuIUYKDWUmEd1EBUIg3JbGyKrUoP76oNCe1+BCjD9AhE5mlRJPzgfGRVxJvaGxg
	bGhoaWhmamlqgENYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVANjTemalvaQ2z/iDO7VuUgL
	m2qwR5VkFx4JEzqYfVN35uPps/kDMgSts2R2TfG0dFL/3nrONnvlzX55Gb78awtPzS1cZTbh
	R0u2rVNFnbvvLjtvoT1Zrmo7bNotzhulbmA5sWOrb84FlQO+H/8prF7jr3Ym7M6NiE7x5q3c
	83RfHM9IuWe6lF+JpTgj0VCLuag4EQBX/LhlbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xoK7d+rUBBlsn2Vhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjP9npjAV3BOsmDh9GVMD
	4z++LkYODgkBE4knCxO7GDmBTDGJC/fWs3UxcnEICUxnlPgyu4UVwlnKJLHs9FlmkCo2AV2J
	rRvusoDYIgJyEk9u/2EGKWIWmMcoMeXROXaQhLCAhsSO73fAilgEVCX2rZ/ECmLzCnhI/Ft7
	nw1inYLEryOrwOKcAvoSnz+3gS0QEtCTOLv+KNMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYJD/Jn0DsZVDRaHGAU4GJV4eDMM1gYIsSaWFVfmHmKU4GBWEuFdVAAU4k1JrKxK
	LcqPLyrNSS0+xOgDdNVEZinR5Hxg/OWVxBsam5gZWRqZGZuYGxvjEFYS5232SAkQEkhPLEnN
	Tk0tSC2CGcfEwSnVwNihHJpjoK7c7TtHX//OV+lPbIdf+2zcsXOTUXf+6Z3vxF19O7e/mD35
	p7H4hqhd1UuSsw4uarWat7lt9usWkRmvT84q/5vj0ze9P1jQ+99yl9bXPMpL9Uqt6kWP7swv
	nWX6WE4rMdTsbffqjaffeh9UU+1fetnWMLA7pGzBqkb3oNIgE1FNbiWW4oxEQy3mouJEAEfB
	IdWeAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull extcon patches for Linux 3.8.



Cheers,
MyungJoo

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-next

Alexey Khoroshilov (1):
      extcon: arizona: unlock mutex on error path in arizona_micdet()

Chanwoo Choi (1):
      extcon: Add missing header file to extcon.h

MyungJoo Ham (1):
      extcon: kernel_doc style fix

Sachin Kamat (9):
      extcon: Fix return value in extcon-class.c
      extcon: max8997: Fix incorrect error check and return value
      extcon: max77693: Fix incorrect error check and return value
      extcon: max77693: Fix coding style
      extcon: max8997: Fix checkpatch error
      extcon: max8997: Fix a typo
      extcon: max8997: Use devm_kzalloc
      extcon: max77693: Use devm_kzalloc
      extcon: max77693: Fix uninitialised variable warning

 drivers/extcon/extcon-arizona.c  |    1 +
 drivers/extcon/extcon-class.c    |    2 +-
 drivers/extcon/extcon-max77693.c |   36 ++++++++++++---------------
 drivers/extcon/extcon-max8997.c  |   28 +++++++++------------
 include/linux/extcon.h           |   50 +++++++++++++++++++------------------
 5 files changed, 56 insertions(+), 61 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQra5aAAoJEBOhurvWBoCK/soP/A/h7YIeBV/k9naDbhcMQ9bP
vtRUXdTziJKyBEjVbUdGx62CBUJkAx5oYLOUp02CZrwITFRWFQvlsP934OVXbzfj
UhGYv7HKlRvAF1jdARXBdIHNyLuPrKBIxv36WYn/GA2SH+1uiV0tLdswON5Y+Hji
T9ukH+6+HnGyewZ3NcCpgfIo93jSxhJXJ1H90ENVMWwJC+YlCtceRmFB+wgy+/9b
JLaSjBNVCIAdMdfCGU8ikv3q2t6YGpP4n52dsEBoRcuJq/xuFNw/27xMhSA11rhF
tG/14ExOj8LehKxhO4Q4ceVI4qt9SDdGfywjbYqk7MdpPLy5eRdX/4wo7/SBzfzh
mRksPv85E9gbGY6ex8wZpfwpwbs0zq8abVbQP9Mmdpddd/xJYMS9r4eJzZRJSN6L
D7Wvi+k2DqxklYe7KGpNt1FVCTs7tNJOGw8+gQ8l/N+DRkE+fq8QvLo46XQJaXRR
Atu74bg4d0DmEaFIkaSN79ps0vNuRfUTq29G5ofQvHuxmbrtmsJ+MOcIY6sX9p0+
0kmvMjentU2fGJ8qu9iJL95/TRUJzo/6GG3VUQIHhVzggJEXUe+EOJIZ47d0A7z9
6/2Sb6oBoiuPSNiYorO6wEh4ml1OkAa75oSxJ38ePiZ0Qvrcjqjgu1L4sPjN00hj
NidgtxwGkzphXtXS6uKc
=yFA7
-----END PGP SIGNATURE-----
