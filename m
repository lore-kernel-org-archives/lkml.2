Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2G3Bhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:37:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37419 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753747Ab2G3Bho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:37:44 -0400
Message-ID: <1343612252.4642.59.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 000/108] 3.2.24-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: =?UTF-8?Q?=E7=8E=8B=E9=87=91=E6=B5=A6?= <jinpuwang@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Mon, 30 Jul 2012 02:37:32 +0100
In-Reply-To: <CAD9gYJKwrcovmGcDJoCMAzQF=zfT2jnk9ghctejWAX1R5ifB=w@mail.gmail.com>
References: <20120723010651.408577075@decadent.org.uk>
	 <CAD9gYJKwrcovmGcDJoCMAzQF=zfT2jnk9ghctejWAX1R5ifB=w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-y8w7DyPDw9mzjDEPkHsS"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y8w7DyPDw9mzjDEPkHsS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-23 at 10:26 +0800, =E7=8E=8B=E9=87=91=E6=B5=A6 wrote:
> Hi Ben,
>=20
>=20
> Thanks for your great work.
> And I found you may miss one fix ([SCSI] Fix NULL dereferences in
> scsi_cmd_to_driver  commit 222a806af830fda34ad1f6bc991cd226916de060)I
> once encountered on 3.2.22.
[...]

Although it was cc'd to stable and should have gone into stable patch
queues automatically, the upstream version didn't apply.  The code being
patched does exist in 3.2, but in a different file.  With the necessary
adjustment, I've now queued this up for 3.2.y.

Ben.


--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-y8w7DyPDw9mzjDEPkHsS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUBXlXOe/yOyVhhEJAQr4bQ//QOkHyOrYRnH6ANwehvX7ZYYJcQzmQuEB
mbEYoJPK4WXP27dxbs2EiQKqEImCCB4RX96pyuCTyme9FMtH/I9eWgbg7AAZXNlp
DNoHbIv/YXe2/YPDXlmb6neVtiQ2NAvBG0LkDnU0AdfarIf+7kvHPOnYhgr8VyCw
QWMBH2ndLptCtWj+/lYervRkzzv2odWoY3TllAA+VFxhlu1xuGdURgLkkrbpsWQx
vsAPxY2bqEPfKHCF4UaJ6gb02SPAgnt922ulRjG5bOOy1X1GondOKmBpu9AMoJ/l
aJ23Jyg13Fm45ZbjEAvEIic/fHWEHrt4QCyYLlPYXfFdImnN8N9K8V2fXcmZBPgI
uddEgE7N/ydSnlfISgsHw+mdfqG87lK6GISa09IRIOME38AdZ9KDgMZDGNStO1He
3ArzsPX235CEhlF55yit7JnFyMPiMkhyphgxjd5Z+PtYo82dFV3lfUB8bufgyPhp
Vk/y91bxnrdlrcUEFPikpVKm0xreQeRpj8vEYFUcRWI+AAzYhL2IRF6KSPzbWiai
bEA8xRXhNtj7Jy1yX6bhh6RPfYmqGojZUifUNbPhEdpTtOVOmIXieqPYL4H2f7lv
x1Hykf0a3KICrL6RGKIER6fBrvbJUNd1qPkmiDWVHUaifjwzmy+MASTtt/mZ11NC
rXBPo+ImhLI=
=LGQC
-----END PGP SIGNATURE-----

--=-y8w7DyPDw9mzjDEPkHsS--
