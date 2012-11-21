Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2KULP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:15:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42598 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2KULP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:15:27 -0500
X-AuditID: cbfee61b-b7f616d00000319b-6b-50acb7ce006e
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com, kyungmin.park@samsung.com,
        sachin.kamat@linaro.org, khoroshilov@ispras.ru
Subject: [GIT PULL] extcon fixes for Linux 3.7 rc6
Date: Wed, 21 Nov 2012 20:15:25 +0900
Message-id: <1353496525-6868-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.5.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zLd1z29cEGJy7zWxxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgynv3azFbwQ6Dixb7DbA2MO/m6GDk5JARMJBad+ckIYYtJXLi3
	nq2LkYtDSGAZo8TGo7+ZYIqmv1jFCJFYxCgxc8YidpCEkMBSJokzs0VAbDYBXYmtG+6ygNgi
	AnIST27/YQZpYBaYxygx5dE5sAZhASOJtTcOga1jEVCVmH1xKdgGXgF3iblHlrNDbFOQ+HVk
	FStEjYDEt8mHgIZyAMVlJTYdAJspIbCHTWLN2r/MEPWSEgdX3GCZwCi4gJFhFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZIUEnvYFzVYHGIUYCDUYmHV2Lf6gAh1sSy4srcQ4wSHMxKIryb
	pqwJEOJNSaysSi3Kjy8qzUktPsToA3TJRGYp0eR8YMDnlcQbGhsYGxpaGpqZWpoa4BBWEudt
	9kgJEBJITyxJzU5NLUgtghnHxMEp1cCYXLCowiL7UsKWY6JXtz5v2a/3nHnu3rvifPHJS7Q2
	zrewmWC9sjc7X2j7Zf5LJ8JMpaIK3s5b86CSnSlyX+2G7OkfeDK3KR6peXb1/PVH4dNYun2U
	n3JWqTGeOeX77t+kCa9mq908L31B/qlSzbQOv1fLnk7a8MGyaPGGwLMr72nLGK8TurchQIml
	OCPRUIu5qDgRAHQEEh5XAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jAd2z29cEGOzeamFxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM5792sxW8EOg4sW+w2wN
	jDv5uhg5OSQETCSmv1jFCGGLSVy4t56ti5GLQ0hgEaPEzBmL2EESQgJLmSTOzBYBsdkEdCW2
	brjLAmKLCMhJPLn9hxmkgVlgHqPElEfnwBqEBYwk1t44BDaVRUBVYvbFpUwgNq+Au8TcI8vZ
	IbYpSPw6sop1AiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBIftMegfjqgaLQ4wC
	HIxKPLwS+1YHCLEmlhVX5h5ilOBgVhLh3TRlTYAQb0piZVVqUX58UWlOavEhRh+g7ROZpUST
	84HxlFcSb2hsYmZkaWRmbGJubIxDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QD4xal1bFK
	uXPYTYw/lsw0yLSqf8+U8Nz+pktrrumxktM8VZ+m3uLPemBw9CfLs6RXgUp+IZ46fHGMRXOZ
	PnLZvX49KWnhqhXrLc5KVB5547V1XeDPU1u8jrjMmXHrl6j+x6rVHIZe7FfPF8kXv5n/9eyZ
	SYdXB4ro1Ucl2x/zsVnB3e+/qzyARYmlOCPRUIu5qDgRAHCEwXeGAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-gregkh

Alexey Khoroshilov (1):
      extcon: arizona: unlock mutex on error path in arizona_micdet()

Chanwoo Choi (1):
      extcon: Add missing header file to extcon.h

Sachin Kamat (3):
      extcon: Fix return value in extcon-class.c
      extcon: max8997: Fix incorrect error check and return value
      extcon: max77693: Fix incorrect error check and return value

 drivers/extcon/extcon-arizona.c  |    1 +
 drivers/extcon/extcon-class.c    |    2 +-
 drivers/extcon/extcon-max77693.c |   10 ++++++----
 drivers/extcon/extcon-max8997.c  |    6 ++++--
 include/linux/extcon.h           |    2 ++
 5 files changed, 14 insertions(+), 7 deletions(-)


- ----
Note to Chanwoo and Sachin:
In this pull request, I've added bugfixes only.
If you see the for-next branch, you can see that the style fixes and
devm_* applications are added for later pull requests.

Note to Sachin:
"extcon: max77693: Fix uninitialised variable warning" is following
"devm_*" patch; thus, it is not in this request.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQrLcuAAoJEBOhurvWBoCKW08P+gO9XqR1cIkvZnQuj8mjjsz5
EUT3TdMtkxdQz4uKU3XRndbfQh0olWMNgg+jhkZXR77+4Ed8pjXffM72ugSJz2DK
zIgQL+J0GYAZw/YY88gsVfDD13OpqFbvzuygMotlVsbMals02YiwTITj4EtVn9I/
CXmHeh73gFk/KPg4ThmbVyVuILzfxcEUOPSPk8WGO8mwSh+7sLBmx+wqB+YU4A0X
6KPLFQhtFLyRuV76nPsd9zhS9VeLUIq7GkfIlDGoODbimGpn3o0C0D2s1/t2X26+
79AnTp6DuRUfv3lBOEn8MuJtXh2P2KHH6trq7GProWBcGefFpeJIlvmU9inRAITU
JKmopUt4d8t3/b1jKFTjIruuIS/EqmYpiepS4D7WIB/Stkjc8+kYWMvMxw27nbGo
cw2NVqyvX4s/eSzVRoQXj41StJpA+t9At3OLRd8kPkf2qh516KCa78Qn4+/jG5GR
ez1wF5C+OcvJ6E3AAionL7W89tJRo/FdmijHsXpwHS2afTxKMgYpeh0LZK6v69+s
o6R4oMNhFGd7uO4sjKMcH1yrUanrzVwjA9N0fs8O+q/Azd2hYsx0ncP7/SLHlYIS
oa2ST2JRLl4UiQf3MfKCzKZ1NOZVvjId8oHqgECEPglDfvj+vQUA40/X4X1M59id
G1q/+RFn2jbKt7QAu0EI
=rMq4
-----END PGP SIGNATURE-----
