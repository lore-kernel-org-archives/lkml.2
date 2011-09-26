Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833Ab1IZEDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 00:03:04 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57252 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1IZEDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 00:03:02 -0400
Date: Mon, 26 Sep 2011 14:02:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doron Cohen <doronc@siano-ms.com>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20110926140253.59d8e295b5b7afdd84c054a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Sep_2011_14_02_53_+1000_uvPR528Q4r.BT9IL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Sep_2011_14_02_53_+1000_uvPR528Q4r.BT9IL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "sms_dbg" [drivers/media/dvb/siano/smsusb.ko] undefined!
ERROR: "sms_dbg" [drivers/media/dvb/siano/smsdvb.ko] undefined!

Caused by commit ea3709435c7f ("[media] siano: apply debug flag to module
level").

Relevant config:
CONFIG_SMS_SIANO_MDTV=3Dm
CONFIG_SMS_USB_DRV=3Dm
CONFIG_SMS_SDIO_DRV=3Dm

I have used the veriosn of the v4l-dvb tree from next-20110921 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Sep_2011_14_02_53_+1000_uvPR528Q4r.BT9IL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOf/ltAAoJEDMEi1NhKgbsjPUH/1OLFM/FYyzxs9UPmgR9K0YC
asPLCCJzWTsMfgx3dllCY2rlBeKxLrKGoyRY4GOMXECTC7t5tmjsm/TT33PI8qcI
YUf7GfZrm8RIq6LdpTNIXJxlOVlFse/Xgv4fxMmOldOWTzMqzmj3ezN+U3hSwDvn
nFE+TxDpuW1UWpMryxSRybiBPtVD+HqaVJCgi0xBq3QwgXSIJX57fxTABKjBR39x
WE/L7HoKBspGIWAb1yjZ5o2HqqA9KODIK/chf0MWO+5pBGRY+vLAT04eRjUGg6yh
SZ/KItuDjsOMCrKKUZTQ46ktUh3DrrW3mDGITkAccX5UCopX1y/Sm67tOf26Z5U=
=IJkL
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Sep_2011_14_02_53_+1000_uvPR528Q4r.BT9IL--
