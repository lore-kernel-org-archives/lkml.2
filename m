Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab2KVVrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:47:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61721 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab2KVVrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:47:00 -0500
Date: Thu, 22 Nov 2012 22:46:37 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4 04/11] pwm: pwm-tiecap: Add device-tree binding
 support for APWM driver
Message-ID: <20121122214637.GC14771@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-5-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-5-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:OYd1M7huQW8aXkBhFMBjX7tW/iCchIOjkBhL15Tv9br
 joTboZfwTdWzW96cIuVZtsYyhLf+aBnJFuIvsMHoWdaYhASs8n
 V0Qu7i/ZTonllnlVjL2na6BoWySXPczlqh9+S7L+ompurw778e
 RNm2rXCkCxKhzyUeDW58rFr5Ksn/eUjw9hQqbY626vhsFLCSca
 k0ub8jumSoGEuEcLSxsijlKht5w/xY5xsRWak6kPuT5HGfIjJ/
 k9NRqofcKttCMdTng8i1sDs3/MWznpgA/aZAdIYH9hm/+GEDxn
 LCAz1NsWUm2Ep9ClRjyjpgE4BPljgw5WS3T/tRArwVPMJO9Zmm
 vA2CL5ERXaut4VyarNPYg8vwccdyjV7F8HNHGZB0QPFbbMejGB
 l5mhNyjtt4cs3T7wMRK70NyA5FmKvfIxfM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I forgot, the subject should be:

	pwm: tiecap: Add device-tree binding

for consistency. Same applies for patches 5, 6, 7 and 8.

Thierry

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrp08AAoJEN0jrNd/PrOh4GkP/A8Iswwdx+/S6keo0GJpL+er
JkJmiWct2o8DqsltawRbnqqlEBxmV2imLvwqiGDNE1WG1+8jDoVe7uiT5aGCocqd
3hZDlNIBEhRfY006MSb6jDSb43AYP/u/JBfLcVi5ZHohLlV3AicinUx1WB0QbY9r
pJNt7agmCjjeoXT2MmVNMrJynyOq374YkEfz+enfwf5Qw7ybvkikvhd84knZi6Pw
GC4Luc6Bkp6tqnM+iaZdMIpbQWAni/iNbRwhar45575SqylovBHk+NS/p37HsMv9
pBPHAEfSmpqH3KG9D5Kp8M2tNX6jaN6YyK6TB80fbFVhm1+rwAF6cfi/AE5cf+XL
BxZRxJA3l3ZgLnLLJXGALDYr6AbUKDWcu+31o/PIvqrpJ65RJl3Y7mIitELtRnUk
a0y5+E7cJQEM9m5t9qp1QG1E+wmnj4lR5BP25s5Tj8u2vU8HXzfuFVKq0BDyYJtx
BCppOroy7fX/xVU/Djigvl50VrwYPgpZGgEaUy7FssEOVYMPVBpPOj3SDqxo9PsV
shpr0ge6521lc8MrCOY9C5nlfZpdSUUPssHvyga/+9Nz0jHj+4Puz1V6vA+jpwAB
UMQcKsxhWatemELNY+atm1UfDFV+kT+XTJstlFlXQ9Kp5CzKOhF5CVuA1VHDJMI1
SQpDPEzvCIlxwZaQd0oG
=luDr
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
