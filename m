Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2CDSCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:02:44 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:23539 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2CDSCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:02:43 -0500
Date: Sun, 4 Mar 2012 21:04:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org, smatch@vger.kernel.org
Subject: Smatch v1.56 released
Message-ID: <20120304180455.GA1003@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="livrSZtJkVq9DDdS"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F53AE42.00B4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--livrSZtJkVq9DDdS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

It's been almost two years since the last Smatch release so probably
it's time for another one.

Smatch is a static analysis tool for C which has a lot of kernel
specific checks.

To run Smatch over the entire kernel use:
	smatch_scripts/test_kernel.sh

To run Smatch over just one .c file, start at the base of the kernel
tree and use:
	smatch_scripts/kchecker path/to/file.c

The main new thing, is the new cross function database work.  You
build a database on the first run and then use the information on
the second run.  The script for to build the database is:
	smatch_scripts/build_kernel_data.sh

Smatch still produces a lot of false positives.  Also as bugs get
fixed in the kernel, the false positive to real bug ratio gets
worse and worse.  But it does find real bugs as well.

There is a mailing list smatch@vger.kernel.org.

regards,
dan carpenter

--livrSZtJkVq9DDdS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPU67HAAoJEOnZkXI/YHqR1n4P/13+XbV8ElBMFtjwFg3kP5e3
LABlVEGvUGYiKo+4JeZcuve0QCM/Ike3tLLHx8DH1YLcwgIn7OzOyM/SOJJcjcst
VLeDjnm7wHVJU9PI3NtODQh0USY4sqkUsZrZubGqiUvn7gD4KRvjbjUIVgGGbh8J
gP4H4XPL12srX2ZdBgB5iFfczabl2Z+yN/uCRLKHRTJwjDPX4MlqQLyq6gpQbQXo
bGzn00CKslmFJ3PvnrZucBVGnFTssQIe/XnQXcmlGoEBrD1f3mU+d5gDlLG8obF3
sUFt2SKcHy+SfMEsfHj4pc5tA9tAxtT5YA6jEf1MBuPXsEbkRHmLaV7nGsc2Ml0W
BP1zo5A/Cq+EhhssEMFdggkFbR78Rxs93/2rGAi7vw7VKm/WTd+d3WjYwShOSeMd
GRXdkEMhDADfGn79xCxOEKobFqyOHnskMI/gOvnBK/oG7C7J35OdHSJ3LCU5gKzJ
93fzeWjkaZH/+KarLWBkfFjyXyNQUeTdqeVnQywlIVLpejAVittL7MgPSX64RTGC
bSC4vQmUapQ35YPJozz04wOeZrb/ioywmnOpdt1ldEmp7x97V4EAJQVzUPF52UF7
EPuMcrgJoA9TPQiBL9dZeOzv24Plce6PCnThRSihkFUfgddg80Z94PAWyjC59NXS
x373y9XzZTS18LQj7SWQ
=fjCs
-----END PGP SIGNATURE-----

--livrSZtJkVq9DDdS--
