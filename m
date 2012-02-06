Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2BFQUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:20:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33711 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079Ab2BFQUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:20:20 -0500
Date: Mon, 6 Feb 2012 16:20:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing
 iounmap
Message-ID: <20120206162017.GM3070@opensource.wolfsonmicro.com>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
 <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
 <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien>
 <20120126110506.GB2611@pengutronix.de>
 <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6>
 <20120126112242.GA9401@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201280801230.2045@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hdhkc9EpVJoq6PQ6"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1201280801230.2045@hadrien>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hdhkc9EpVJoq6PQ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2012 at 08:03:34AM +0100, Julia Lawall wrote:

> patch against
> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git

Hrm, I know there had been some debate about what to generate against
but this now once again fails to apply against for-3.4...  No idea
what's going on there and I didn't investigate the conflicts, sorry.

I had been waiting in the vauge hope that some of the mxs maintainers
would review.

--hdhkc9EpVJoq6PQ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPL/27AAoJEBus8iNuMP3dAHkQAIPFIMEo18/EJOkgCE2lz4M2
RrvBrBnyqJDGkLiHeQhoVjRZ6nrRRWB6pKvlbUC9EoqsZmF8NEB5PFMw9ER4HgYh
zUZDCm6aIlr5rkXBnfe+pmDdlEfLLy5Ypcd63y9XVaY6eDy6+BZc6lMCyco7xE34
u9RvPA9hrAJ3mwVkNkokA/jd0Qq5YpUiEOY6nX3m5YaFmM/9nRzjLWVZplfmyMNu
Zjl+7PaWgeqKwimufMHaVjeIdAQTaHn5G0itH75gUn4pXa6B1wTni8+AC88sFwMQ
ODCsNrCt4mokeqCYVhwU8XypYg2iyYcD63vJjsLSzjJ5AmIaRfU/4+6G9bMhP0y9
uqPxsc1UJQqXo1HuoBSjMiM1HOLANE7UA+jLxdyCfd62hdRXyV90SA4NZe1TotGj
MM58sM/4lXy3H2UKlpwH3p4/wJiuVBz+S4br0gzKim9f7c1lgaxvyagLn+35JL/G
SglmCZ8ascnjb3UjatfvASaoxl/A1TNRB9Sc14gLSBFbHi9SSXWfpEN4av+DZkaz
95LQR2w5ntqFEvssYMeJkSvLVWUdVPjCk7SVLsx2QH0lMCKWatALQlJ0nThOqSqQ
PbOJXhhhzsURXOwSPk8wr7jYhE+iaA294QxeisEdDd1WPtXKRuUoCMwrfnQMyPk0
ZSQCghDGoTW9rbgDXUIV
=Rd3a
-----END PGP SIGNATURE-----

--hdhkc9EpVJoq6PQ6--
