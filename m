Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab2JWEOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:14:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55428 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2JWEOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:14:04 -0400
Date: Tue, 23 Oct 2012 15:13:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <florian@openwrt.org>
Subject: linux-next: build failure after merge of the final tree (usb tree
 related)
Message-Id: <20121023151354.497d9b4f25b9ce7ff54e0785@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Oct_2012_15_13_54_+1100_0.7rlnxdqA890_p8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Oct_2012_15_13_54_+1100_0.7rlnxdqA890_p8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/usb/host/ohci-hcd.c:1165:0:
drivers/usb/host/ohci-sm501.c: In function 'ohci_sm501_resume':
drivers/usb/host/ohci-sm501.c:241:2: error: implicit declaration of functio=
n 'ohci_finish_controller_resume' [-Werror=3Dimplicit-function-declaration]

Caused by commit cfa49b4b88fe ("USB: ohci: merge
ohci_finish_controller_resume with ohci_resume").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__23_Oct_2012_15_13_54_+1100_0.7rlnxdqA890_p8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhhmCAAoJEECxmPOUX5FEY3AP/0tdrijETfk9SgoeVyOh0DJy
aB+3tAWqXyo7tocCtqRH91WBcHDSKpih9mFfMhVWD8wni1DYAbNtXipfqXQO/cOx
Az/kgeCy+FH0aZS/lVQh5QaZj5Dei69lESoBDsMwnFeUTvbio6zGtgrVxzn6g1sK
RCDNgfbTIm+S3/TRDjrBdd5cJXfYth3QbivY9I8NyW2LAUmcH61zwpoxxOI/9wRc
yQy5PYifHWVsAcOlE0KwhOd/IwiSpaUAGs+Y33EynBMY6XaNBSMh+43W1RYbIpfY
6da6fG9tUQsPX6UomXq0Ix6F0WsVSDOL8oiEE2o3qauDEyxfVhb4gp9e2w5E5JJa
xrE1euJIgjh7c6dpmom5KI9IdvQPInQqFyxBcukMrniFqNuQSf8OCutA0KiSHDWc
rzEQlHWq7nEwA0hzlEWtsgyo6EBr5cj80nBWqACERZ5ve4/DH5ofIkAnx+a76fyI
H7x9xfviqcSzHloS6Rqs+W7zhAohL5gz4P5phLoAQTBjyZYs8COmgPSEaP10X40M
Ckz/lpD564b9inEdECX8tLN9XtH7YcavnSBjoKCFccOsacaWv+B8T6kQv1pIPSN8
ZOfOCRo2YLlFtKBaE2OhOe6Unx6CqL7jMo/ZHwQpm61uF8YKgnMNzRQNJ6SBQcQU
Gg+5WbNJVF3ylhKcDWoZ
=YcxL
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Oct_2012_15_13_54_+1100_0.7rlnxdqA890_p8--
