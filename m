Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab2GCNYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:24:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51048 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183Ab2GCNYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:24:49 -0400
Date: Tue, 3 Jul 2012 14:24:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120703132447.GN29030@opensource.wolfsonmicro.com>
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
 <20120703123552.GC25995@sirena.org.uk>
 <4FF2EEA1.6080204@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0kRkyLZR5zsR9u2P"
Content-Disposition: inline
In-Reply-To: <4FF2EEA1.6080204@linaro.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0kRkyLZR5zsR9u2P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 02:07:45PM +0100, Lee Jones wrote:
> On 03/07/12 13:35, Mark Brown wrote:

> >Do we really want to create MFD cells like this (which are really Linux
> >internal things and might vary if another OS or another version of Linux
> >changes its internal abstractions) from the device tree?

> We're not creating them. We're merely using current infrastructure.

*Very* recently added infrastructure which caused you to notice this...

> Before, when we probed each device from Device Tree we came up
> against some fairly major limitations of the Device Tree. As a
> result, Arnd and I agreed that this was the way to go.

I'm really unconvinced that instnatiating the MFD cells from device tree
is in general a good idea.

> See c5395e7ed8f16cc7bb72a783de68659db5aed515 for a short description
> of the troubles we faced.

$ git show c5395e7ed8f16cc7bb72a783de68659db5aed515
fatal: bad object c5395e7ed8f16cc7bb72a783de68659db5aed515

--0kRkyLZR5zsR9u2P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8vKXAAoJEBus8iNuMP3dN1YP/2eNLP9EFGR9jHlphRG0ys1P
E51sl5Se3gq0aHk0f3VFzTjCRiyE5o/X9tEGSa40Y12qCwCi0tW9AbelMKC7ppaT
82whclHIIrBLbOW/zl/EAiuEWYGIj3HSDqcwp/2K4l/LzLve3MKiCGVgfdL6GBi8
MWndMfnGZbAC6mhRwoVfHmK3H3Xw6116nkVqVIWaM+s6hEiCjA6GeZP4w/KgbuM0
xYej90EfPNtHAV6SCWasMIidtE99q8iyk9x1HgNFguoreF9f3IDwFdfEnJfVyib0
JLuZQkA+gvprNMin8wTrzoF+HZulcuSrl2HWHFpKE14m60To6Ie22vDV9if70PRc
aADTiSEMNiyOWxNfXvUDYuTQkZyKKQvH8E98BN3NBjce3qRIPQ2g8GEkTX0a20MS
Q5KQCeZZRLK2ADjIw49VWRs7sbCW4FglfZEWDdNUNnJ0bxEBdTqlTgD1TxuK0hpI
3EfZNSAp6wsWGOsUe3w+CagcPahHunoqnSW0132MWAuDeJFBoj+DcyGCeFJKtQ/p
1o96ZYZclGsPiRDs9T25xlGqkHq3OeKRk7dTr0CXf0vFBxWNkJAOroW1r4MARMmP
iSJ2KZUF0ulVJVPtkunq8C4Rpv0zpr7d3LFMwEt6oWBnSj2R5Wgm4w3I4UxHkWU8
M/LHW+UUwV8sN+LR0gQ6
=g9z5
-----END PGP SIGNATURE-----

--0kRkyLZR5zsR9u2P--
