Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0CXJEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:04:13 -0400
Received: from vps.mortis.eu ([79.99.135.181]:42269 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0CXJEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:04:12 -0400
Date: Wed, 24 Mar 2010 10:04:08 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: watchdog simple example: don't fail on fsync()
Message-ID: <20100324090408.GD6368@salidar.me.mortis.eu>
References: <1269260557-18150-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <1269260557-18150-1-git-send-email-me@mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2010 at 01:22:37PM +0100, Giel van Schijndel wrote:
> Don't terminate the watchdog daemon when fsync() fails because no
> watchdog driver actually implements the fsync() syscall.
> ---
>  Documentation/watchdog/src/watchdog-simple.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

Seems I forgot to sign off my own patch:

Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkup1YgACgkQZBYm/87l50KS0QCgvzWSD68zYzctq//4Zt1EUefI
Cw4AnRmToMRF9Ihkv/zHpxIKDdjK5eUx
=i0ui
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
