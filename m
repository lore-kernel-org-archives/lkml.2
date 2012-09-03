Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2ICOR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:17:29 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:34095 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756473Ab2ICOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:17:27 -0400
Date: Mon, 3 Sep 2012 17:13:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: gregkh@linuxfoundation.org, balbi@ti.com, hzpeterchen@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] usb: otg: Move phy interface to separate file.
Message-ID: <20120903141306.GL3147@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346222821-27650-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xtmLDbP6TiKhntQb"
Content-Disposition: inline
In-Reply-To: <1346222821-27650-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xtmLDbP6TiKhntQb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 29, 2012 at 12:17:01PM +0530, Venu Byravarasu wrote:
> As otg.h is containing lots of phy interface related
> stuff, moving all phy interface related stuff to new
> file named phy.h
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

this doesn't apply to my "xceiv" branch. Please rebase there so I don't
cause any issues to your patch ;-)

--=20
balbi

--xtmLDbP6TiKhntQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQRLryAAoJEIaOsuA1yqREZQ4P/3YKc/EECfyqyzoh3RgEvGUx
AKcJNDg8V9vF8nIHmr6Xz1V2ZtUV21zHfCxNrxdQ4m3BTlT9LYhCOIH4pWBAKBvS
aGAhmOu60XudpR0EZl+6gDmcEQuQJMO2mYTzXRfRzfMkSlc1vYPbmZcdNBBahGLs
Jw6GkJTte9VrY2OAUOU9MQ+07Nt1mDAkvd1ekROGGk5LwsszlaoHv6ZdOHRsVGoL
6UNO224cQo5E2oQWOS87vNobcQEn7ubNYHMaJsYp/hCRLzwqEAS4mWcZ0fW2IRlu
050Up5rM8gIHzobULF48pIUMExhhGfetFh3NBWtyU/MVsry5gKMUOSKnI6Sx8y0c
o3z6oJC3LNP8VVi+STTPgX6hwVqojAGwh0OtZbuf1xXuc7k+U6lut+omFWycAn7z
zIwyjYKGAXMJh6riGEdytGk5WLFZrst761i1cjF01OsBN5vYjV5/x9693ArtPpzk
kwiMt+fX22Q8L6KnCtwvwxloboLWdVm2F0Izhwm8VP3KGealQMP6bVGL4AkIw/v+
kVSxB7GeR4/12ncAttF8aInMvdF8QgVXnXaijlIGToQjkWi39x7pC4NsoGJYtmxK
LcrGHALbWYDHm/AwhBxYBdWKwWIJ/9nbdMSGd5H6xKzK9N0rclvPmDYsbXcf3SY1
9uvOygG2JCnevxoUuc+F
=SV1s
-----END PGP SIGNATURE-----

--xtmLDbP6TiKhntQb--
