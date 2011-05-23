Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1EWFGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:06:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40245 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab1EWFGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:06:40 -0400
Date: Mon, 23 May 2011 15:06:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark gross <markgross@thegnar.org>
Subject: linux-next: build warning after merge of the suspend tree
Message-Id: <20110523150636.ccd83777.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_May_2011_15_06_36_+1000_kxuSAlpJ1ioUnjhU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_May_2011_15_06_36_+1000_kxuSAlpJ1ioUnjhU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the suspend tree, today's linux-next build (i386 defconfig
among others) produced this warning:

kernel/pm_qos_params.c: In function 'pm_qos_power_write':
kernel/pm_qos_params.c:420: warning: passing argument 3 of 'kstrtol' from i=
ncompatible pointer type
include/linux/kernel.h:210: note: expected 'long int *' but argument is of =
type 's32 *'

Intreoduced by commit 365daa955e03 ("PM: Correct PM QOS's user mode
interface to work with ascii input per").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_May_2011_15_06_36_+1000_kxuSAlpJ1ioUnjhU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2etcAAoJEDMEi1NhKgbsEu8H/R1wg/xsnVPyfw0hHU3m9oGu
h1KkEdSlsUwO4Fwl1AemhsfIuSVjbsxDftFPMgK/6TLjrydTVT3zwvdZ/GAIJLGX
N/I9lzGRCN0mjAc5LHNcHD7vhN27YB6sb5dy2d3SEYPMgZ2+HiIk2f+mBA8akCqy
NaWpTVKrXtKAzfzI238nkxcSJJLXH6K9oc/eSSnNpWQ5xi/njZDj5U3ljs6kovA0
PpqXM2zeWZloEC37DakOUHmLG6DrZS9uHqmzduwSSi1mHpe5u8J7Sj6KxJe92r5p
UeSUf1ipXymzIo6voPFsBN5VWa3CvCxrLXNYl8ww+T5TPw19YKhk6fZEn9io6Lg=
=ha5Q
-----END PGP SIGNATURE-----

--Signature=_Mon__23_May_2011_15_06_36_+1000_kxuSAlpJ1ioUnjhU--
