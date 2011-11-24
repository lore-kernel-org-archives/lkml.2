Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1KXCD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:03:59 -0500
Received: from home.keithp.com ([63.227.221.253]:60935 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab1KXCD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:03:56 -0500
From: Keith Packard <keithp@keithp.com>
To: Patrik Kullman <patrik.kullman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: i915: 3.2 rc1/2 KMS regression
In-Reply-To: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com>
References: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 23 Nov 2011 18:03:59 -0800
Message-ID: <861usye0og.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Nov 2011 00:43:03 +0100, Patrik Kullman <patrik.kullman@gmail.co=
m> wrote:
> Hi,
>=20
> With the Asus Zenbook UX31E, kernel 3.1.1/2 works perfectly, but 3.2
> rc1 and rc2 freezes on boot with KMS.

If you can bisect between those two versions, you should be able to
isolate the change which is causing this problem. Without that, it's
unlikely that we'll be able to help much.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTs2mDzYtFsjWk68qAQjIXQ//TWEmCijSFsCGcsqmq7NFQKhzK8nXptP3
lhzzZqDD68iLYrADEtiH8BBBZgyaV/BpY0NhYRAaLEmTmwDAQJGuB67+RV+m0zoq
D8mmDAaTzQtU2QfcGCR3heio0c3Xc+JvQtE0VayFkmq6fNbsef+d2aa1i03QGRmb
Hj5jUAKf75sMPH12fphTpx/+j81TNX+NqwFwEKlkGSgekz3UcTkSnZcjP4ty4qQZ
IgN9S3ijEHya7Ea9FDxaJtSlhS8mhM8Y2h3Lbc/F9hoo2qrj6V4MHKq4fSkUUBqC
SfoPkQCN/mYABdTDecFJE3XcnDQKUyo5/4+d38Wt1Hv6C5wJUAWz3r1CWs5MQSoR
F5vOanrqVnBOUF4yYl8VQWAqwaCe4Nq6GOx7AcrCmSddzpEOhCnOuoQ2im7Zxh9W
E+v8y+uK2c0LhHun+5TcFSC0xFAEbn9U2V9EquIbCWTpXAwxEK/COlZRmyKm2aMD
/q5cCd1wbs1eVdRmCHoTA1GdY9FzsuukQfgH1SZYOYHbq9UZTQ2NI4mprGm8dcRy
2tpAMvGk9vfSC2xB/lp50Dnw3Vh3U6pzFRZsoHu08RgUbjigqz1xLrof5/nLtU7U
wJdXz9LaEqjFzrxzHmijaHeIJU3kjxNBDwPTNUtyrrDeHY1OBUOEoyJ22InPTEox
a6V/wim2fzE=
=fwhT
-----END PGP SIGNATURE-----
--=-=-=--
