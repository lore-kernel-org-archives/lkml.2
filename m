Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2EHLq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:46:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46952 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904Ab2EHLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:46:58 -0400
Date: Tue, 8 May 2012 12:46:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps62360: fix stylistic issue and optimize
 code
Message-ID: <20120508114655.GK15893@opensource.wolfsonmicro.com>
References: <1336476958-18620-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Content-Disposition: inline
In-Reply-To: <1336476958-18620-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 08, 2012 at 05:05:58PM +0530, Laxman Dewangan wrote:
> Fix multiple stylistic issue like:
> - The print message should be not break into multiple line.
> - line gap after variable declaration and statement.
> - checkpatch error.
> - some typo.

I've applied this but please in future always split changes into
separate patch rather than having a single jumbo change.  There's=20
lots of different things here, things like the switch to using
gpio_request_one() should have been split out - this makes review
very much easier.

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqQeYAAoJEBus8iNuMP3d43QP/ikhrPXljN/L9iPABlOUJnNL
lIPAgqBsHaIPCRi8iVqhQPnYUj5UHKUIQPCZOdmR807s46WURLkb7v7+2KHGnkXI
lr6kNseQXX5O6FZ6tSHk3GIfuBkpf05vBMqSs7iCaCqn9cStKJM0NEVzURxPMkxJ
GdL1j7Eta/N09BX98QTD08yrx5svZ7AetRY2GB+zeSLRoyPgbi640qJtUkQfiPNh
cRLVksUnhwkojWSuqmYWDOg11b9OQBXz5tr7ZZwCMccYdt0mQJAdkjHUpX92MoNN
PNUxD6Zu4C1dEqgmzO1VL+9toi167LKIz6CCPiyqQ+wa4ePxCkT3OXSL/ejTbfOr
1IUKJpE1j7sv87VCnoWYIC9KlNPBr1VmwZlfLkp8RMueDCBnJAqjMZPRQz664sU9
lJ29hDPxThv/f/B4VqXGuml/I5XWehofYt6cyy73v51+X6rDtlIy7LhqhxAz6NaW
7pFb+zj/iZC/eJmXM8TiYYMR2BOs9oAhvmgKl7iPi72zCt0sDjutwU7/9I9gWTHu
3vriIeiQlF3oDLBOm87eA3r8RNE48z886CYDvIg1JTHW6qBs15aRhOBHOGHAvXbv
OHq6H+xZMD3OroM3+iCUJVa78aRPprvNoI6iIydHBxMtG8kJC4fYOfkHac3dHL/+
CxeDeHRP7ZLstuS88EYk
=jqLK
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
