Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2JVN4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:56:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47549 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872Ab2JVN4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:56:04 -0400
Date: Mon, 22 Oct 2012 14:56:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max77686: Make max77686_enable() static.
Message-ID: <20121022135603.GK4477@opensource.wolfsonmicro.com>
References: <1350878968-3020-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dwWFXG4JqVa0wfCP"
Content-Disposition: inline
In-Reply-To: <1350878968-3020-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dwWFXG4JqVa0wfCP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 09:39:28AM +0530, Yadwinder Singh Brar wrote:
> This patch fixes a sparse warning. Since max77686_enable() is a callback,so it
> should be static.

Applied, thanks.

--dwWFXG4JqVa0wfCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhVBhAAoJELSic+t+oim9QxEP/i7QUfMUj8dax2ciSTzQUeOY
Up649lAovdb9ZdGAr6hG9vvoCjqjvBjNmTEbfaI8iqx0p+OvyjRYvk6L0M/3o1ZD
7x2qFny4gZ/z0Dz/Np43M99+jLdu7r651Xqqm2CVFFZxqNFSQvF1vIfiCoeKJKWo
pE3kppbEfvvG/9jM/AebM+0P+wjNqVVoj5He7Mc1HLisZ+iqqSMDv/i1un9aPDVM
E3hHzkaG7V9TFiAPxwLFWLRUIuEMtpx0C3He68uKk9ar9jd1z6rQQ18jUvtVfFaK
3Is3jjfTKWSNDlhAAPwcnUrJXQ8EoupqcjSnGG1C1MbiyNPwFapW2ZYv0dL1NTWk
SY7PQ/m38XxcFRuE0tA+ZPt6KWXP2nf32p+/+vNK6rmCFsLoicCmUIEakCy7WAT9
pXNhTw1qaTq2gZdSJsiXy104/jLx946J4OCwrbZMsbBnkZUT7q4cybVNyXR/huoi
ojjgOF8KiWYND6aq2AzXB3cZqAebwpBWM8PJJxyvqVTggFmu3GTZlUSPsxDuVCOV
XN7yQ0vo/IKwGYhp5fCt/O1LV9BAUqvZ1JkO+r5iL+1e70IkAqk/zxUtgH628Ulj
71L0yaOOj1hb8wcH5zFafNu+gM732WOvdVfEAIPR2myyd4d0mFcmDKte1Ys/2HDf
0eeJEX7KPiWceeIJVeIU
=5UkL
-----END PGP SIGNATURE-----

--dwWFXG4JqVa0wfCP--
