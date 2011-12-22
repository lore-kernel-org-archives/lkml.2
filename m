Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1LVApw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:45:52 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:60962 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab1LVApu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:45:50 -0500
Date: Thu, 22 Dec 2011 01:45:20 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: Keith Packard <keithp@keithp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: GPU hung with Linux-3.2-rc6
Message-ID: <20111222014520.7ace1ab2@x220.fritz.box>
In-Reply-To: <861urxy1pw.fsf@sumi.keithp.com>
References: <20111221195410.5e4c065a@x220.fritz.box>
	<864nwty9sq.fsf@sumi.keithp.com>
	<20111221222626.0b8c3a30@x220.fritz.box>
	<861urxy1pw.fsf@sumi.keithp.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cZkCAJTKMnGlTYL2RAqO5pb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cZkCAJTKMnGlTYL2RAqO5pb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Dec 2011 14:55:07 -0800 Keith Packard (KP) wrote:

KP> On Wed, 21 Dec 2011 22:26:26 +0100, Udo Steinberg <udo@hypervisor.org> =
wrote:
KP>=20
KP> > That makes the problem go away. If you need more help tracking down t=
he
KP> > problem, then let me know. I can reproduce it fairly easily with some=
thing
KP> > as simple as:
KP> >=20
KP> > 	while true; do dmesg; done
KP>=20
KP> Are you using SNA?

I don't think so. I'm using the following packages:

xorg-server-1.9.5
xf86-video-intel-2.15.0
libdrm-2.4.25
mesa-7.10.2

I quick google search suggests that at least some of them are too old to
support SNA.

Cheers,

	- Udo

--Sig_/cZkCAJTKMnGlTYL2RAqO5pb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7yfaAACgkQnhRzXSM7nSlqvQCfS9ep7C6UoULuICAXs4cxZNhB
z10AnRToKYBVHe31t8GRfvXux48O7zyT
=X/UP
-----END PGP SIGNATURE-----

--Sig_/cZkCAJTKMnGlTYL2RAqO5pb--
