Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab1GFFJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:09:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54228 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab1GFFJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:09:25 -0400
Date: Wed, 6 Jul 2011 15:09:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20110706150916.13ff2bc5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Jul_2011_15_09_16_+1000_H6n/iw01Jg1mJIgI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Jul_2011_15_09_16_+1000_H6n/iw01Jg1mJIgI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

make[4]: *** No rule to make target `drivers/staging/gma500/cdv_intel_crt.o=
', needed by `drivers/staging/gma500/psb_gfx.o'.  Stop.
drivers/staging/gma500/cdv_device.c:28:24: fatal error: cdv_device.h: No su=
ch file or directory

I see that these have already been reported elsewhere - it would have
been nice if these patches had not been added to the staging tree
destined for linux-next until *after* they were build tested (and
fixed). :-(

I have used the version of the staging tree from next-20110705 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Jul_2011_15_09_16_+1000_H6n/iw01Jg1mJIgI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE+38AAoJEDMEi1NhKgbsSb4H/3lpzN+FDLn4xqr8UPtzo1Hl
uo9SrnMSAGHiz49h6MveHVm+nWBwLWF7wVqN41XSRKmpb1mCORqeT28UZeleaOuW
99PXdy/wntYi9yJsx12lysRudcKb8edXTrfpmm3z5jNQ5httWCYbWdxUDgTlYgBy
XQW8U3ri18mRMLt+XXbBs6Izw+yuAxRYd6dvf4BkaLsxySnKToOoAG302my5oAfj
jmZSF7JIrudRvbdJ5+jfus/hNEVQ17hSWWSIbUchUJjPaJHzXjeQX/w9iwqPulG0
OH4qNzSHiICsw/k+zbqZXemFTWzrPDw1h4YbnAymltfnTNa4fWJZtll7Q6VOhtE=
=0Eq9
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Jul_2011_15_09_16_+1000_H6n/iw01Jg1mJIgI--
