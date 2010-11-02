Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0KBAfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:35:12 -0400
Received: from ozlabs.org ([203.10.76.45]:43376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0KBAfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:35:09 -0400
Subject: Re: [PATCH] drivers/char/hvc_console.c: reduce max idle timeout
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <201010271659.o9RGxrMc009847@farm-0002.internal.tilera.com>
References: <201010271659.o9RGxrMc009847@farm-0002.internal.tilera.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4k4D+9f+1rOX9vb6Ps6h"
Date: Tue, 02 Nov 2010 11:35:08 +1100
Message-ID: <1288658108.16790.13.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4k4D+9f+1rOX9vb6Ps6h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-10-27 at 12:54 -0400, Chris Metcalf wrote:
> The tile architecture uses this framework for our serial console,
> and our users complain that the delay of up to two seconds feels like
> the machine has gone non-responsive and is disturbing.  By contrast,
> a delay of up to half a second feels like just the normal sort of
> delay caused by swapping, network lag, etc. and is not noticeable.
> The overhead is obviously not much greater.

It's 4 times greater.

We picked 2 seconds because it gave a reasonable trade off between
responsiveness and load. I'm not convinced that half a second is a
better number.

cheers


--=-4k4D+9f+1rOX9vb6Ps6h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzPXLwACgkQdSjSd0sB4dIPfwCdEiPhA3IsXqmoqmHBE/xKE7+3
YhwAoJC4YPrHS49jyJVGY4EmgyF5GCyG
=Fa+n
-----END PGP SIGNATURE-----

--=-4k4D+9f+1rOX9vb6Ps6h--

