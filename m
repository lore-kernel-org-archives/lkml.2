Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0LUHML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:12:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36136 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab0LUHMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:12:09 -0500
Date: Tue, 21 Dec 2010 18:11:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: build warnings after merge of the tty tree
Message-Id: <20101221181158.53f62590.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Dec_2010_18_11_58_+1100_jVVOSPqfWUgvWEVB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Dec_2010_18_11_58_+1100_jVVOSPqfWUgvWEVB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

drivers/tty/tty_io.c: In function 'tty_init':
drivers/tty/tty_io.c:3309: warning: ignoring return value of 'device_create=
_file', declared with attribute warn_unused_result
drivers/tty/vt/vt.c: In function 'vty_init':
drivers/tty/vt/vt.c:2997: warning: ignoring return value of 'device_create_=
file', declared with attribute warn_unused_result

Introduced by commit fbc92a3455577ab17615cbcb91826399061bd789 ("tty: add
'active' sysfs attribute to tty0 and console device").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

P.S. that commits subject appears twice in the commit message.

--Signature=_Tue__21_Dec_2010_18_11_58_+1100_jVVOSPqfWUgvWEVB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNEFM+AAoJEDMEi1NhKgbstowH/0+Er7mIDPs2fWnjU7TkCQve
XdI1CmLmO4MaAReWIlnLJldxqRVeYJBe6dQx42FIPVpm9jeOHuDutPdXjIqlcxS9
twEFeemUzLAqSI9LigFeJY8ZX70BhQtE29QuIa1t/6hxCtHE1f45QSwe/CLc/Eiu
brsUdxWJ2fIhj343WpvAmPtA1gfe/03T02wHaw/3hbEtRBwFdIyg+PIWF+9xbUsC
tL0PFbJwccR6+Q813/dIgqrjdyK53T+SesJ8WzH/DsPs3EaFazFw+kOcfFdsf8zE
BP0K/BK8ywIVGemERblGbPPfH5usVDKn7MeUiNFf58ZKy5ZjBtQC0mNIlgCvXk0=
=Q1uw
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Dec_2010_18_11_58_+1100_jVVOSPqfWUgvWEVB--
