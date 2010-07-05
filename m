Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0GEQyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 12:54:12 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:40162 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0GEQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 12:54:10 -0400
From: Eric Anholt <eric@anholt.net>
To: Ondrej Zary <linux@rainbow-software.org>, David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] intel_agp: Don't oops with zero stolen memory
In-Reply-To: <201006161013.53612.linux@rainbow-software.org>
References: <201006161013.53612.linux@rainbow-software.org>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 05 Jul 2010 09:54:06 -0700
Message-ID: <87bpal3m4x.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Jun 2010 10:13:52 +0200, Ondrej Zary <linux@rainbow-software.org=
> wrote:
> When "onboard video memory" is set do "disabled" in BIOS on Asus P4P800-VM
> board (i865G), kernel oopses with memory corruption:
> https://bugs.freedesktop.org/show_bug.cgi?id=3D28430
>=20
> Fix that by cleanly aborting the initialization.

Applied to -next.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwyDi4ACgkQHUdvYGzw6vdZugCfT+J38/0cN18hy0BfQT8Y45gJ
HVgAn2MOCVAk6HCbCwhiObHBLbH8dz8G
=F5i5
-----END PGP SIGNATURE-----
--=-=-=--
