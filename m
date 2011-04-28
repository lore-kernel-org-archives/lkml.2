Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1D1C7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:59:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42923 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab1D1C7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:59:22 -0400
Date: Thu, 28 Apr 2011 12:59:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20110428125913.9699516d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Apr_2011_12_59_13_+1000_atd61MPmz4Xd5FBl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Apr_2011_12_59_13_+1000_atd61MPmz4Xd5FBl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/rt2860/common/cmm_data_pci.c
drivers/staging/rt2860/common/cmm_data_usb.c between commit e9c549998dc2
("Revert wrong fixes for common misspellings") from Linus' tree and
commit fefecc6989b4 ("staging: rt2860sta and rt2870sta: Remove drivers
replaced in net/wireless") from the staging tree.

The files modified by the former were removed by the latter, so I did
that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Apr_2011_12_59_13_+1000_atd61MPmz4Xd5FBl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNuNgBAAoJEDMEi1NhKgbsdvAH/Rne6vc90BSKSlzHvudb4ZU0
Vd+Z2iKtHmgSf0xeA7x+gBCrG2Xl9xGcLBzAVR0yKFepdWEUDMDjPYiRljfLO/Rx
LoAxmsVF2JHQ3Cm2F9Oe7EZVCD5ooqq6m8jwonl1IFDa3TRo7iNv4oEj8YHCAebR
DW+6J977l3WCToTGuf0CKPRnKiu7OZGeusHD2q4/sARSDrLA4IKq5cAbZJUSnvWH
hWY3d1VKzRQMBn7BVVtEXAUUEorcXvuSCHrLxB5lla1kix/CrCfFgIOc0gA9liba
J2Xpd8j0TajQsbQrvm89EpfeHh2/H/0hLC1BQSX6I9PYjevnBB++hsUisBu666Y=
=jwn2
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Apr_2011_12_59_13_+1000_atd61MPmz4Xd5FBl--
