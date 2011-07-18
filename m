Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1GRIgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:36:50 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:43724 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab1GRIgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:36:48 -0400
Date: Mon, 18 Jul 2011 11:36:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Wendy Yuan-Hsin =?utf-8?B?Q2hlbijpmbPlhYPppqgp?= 
	<yhchen@faraday-tech.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/5] fusb300_udc: Add missing breaks in switch/case
Message-ID: <20110718083640.GB2837@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1310289795.git.joe@perches.com>
 <08f6dd600dbf588e87734b3a6b33d897cd253fe3.1310289795.git.joe@perches.com>
 <20110714080830.GA7149@linutronix.de>
 <B3F95056718EDE47B73D925D2FF34506782BC2@EX1.faraday.com.tw>
 <20110714103624.GG7149@linutronix.de>
 <B3F95056718EDE47B73D925D2FF34506782BDB@EX1.faraday.com.tw>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <B3F95056718EDE47B73D925D2FF34506782BDB@EX1.faraday.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 14, 2011 at 09:28:46PM +0800, Wendy Yuan-Hsin Chen(=E9=99=B3=E5=
=85=83=E9=A6=A8) wrote:
> >>>diff --git a/drivers/usb/gadget/fusb300_udc.c
> >>>b/drivers/usb/gadget/fusb300_udc.c
> >>>index 06353e7..453bc0f 100644
> >>>--- a/drivers/usb/gadget/fusb300_udc.c
> >>>+++ b/drivers/usb/gadget/fusb300_udc.c
> >>>@@ -688,10 +688,13 @@ static void fusb300_cmp_dbg_fifo(struct fusb300_=
ep *ep,
> >>> 	switch (length % 4) {
> >>> 	case 1:
> >>> 		golden_value =3D *tmp;
> >>>+		break;
> >>> 	case 2:
> >>> 		golden_value =3D *tmp | *(tmp + 1) << 8;
> >>>+		break;
> >>> 	case 3:
> >>> 		golden_value =3D *tmp | *(tmp + 1) << 8 | *(tmp + 2) << 16;
> >>>+		break;
> >>> 	default:
> >>> 		break;
> >>>=20
> >
> >>That is in an #if 0 block. Maybe we should remove the #if 0? Yuan-Hsin?
> >
> >It's ok to remove the #if 0. But the warning will occur while compling.
>=20
> By removing the #if 0 block I meant to remove the unused functions
> fusb300_cmp_dbg_fifo() and fusb300_dbg_fifo(). There should be no warning=
 then.
> Are you okey with this? Are those function required?
>=20
> These funtions are used for debugging. I think it's ok to remove them. Th=
anks.

maybe make a debugfs interface instead ?

--=20
balbi

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOI/CYAAoJEAv8Txj19kN16WgIAJ0PhCTcFgIn7axT/2VCse9F
y55rLOMl/MIatrLIRswg3zkGKLSbq9tuLBB3uQK0NARVEpWetF8qC/CkYZ2RSHqn
rX59hKaUrLx1GIIsIIm7shzKssBQqT8BnnStOb9BaxA7Mz1vRVU4JF6s0UmoODrY
n4alzA1uPIR3RbKUCQJt9EKxFG9KFb0FV/6Kbju4uADbI1nc429tOQW6pet4v/ZE
4tE+/vO89JPNHE9zvTtCtfH9HlZrpa2Z7GbGA0ZdfS/y/6la3n3L+gdfDz8U+85D
W8qSWU5TglKvT5VJTOk1e07xgQzfJMN52gNwc20aV0d9vFQycg7DVVGYnHhCdpk=
=FKyP
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
