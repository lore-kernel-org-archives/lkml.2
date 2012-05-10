Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2EJJgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:36:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60074 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103Ab2EJJgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:36:53 -0400
Date: Thu, 10 May 2012 10:36:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the regmap
 tree
Message-ID: <20120510093650.GL3908@opensource.wolfsonmicro.com>
References: <20120510142552.35f8e15042053707a2086905@canb.auug.org.au>
 <20120510085355.GC3908@opensource.wolfsonmicro.com>
 <20120510190554.6055315139a68ef0b1c48261@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pz0BBB9QxoYXlT+x"
Content-Disposition: inline
In-Reply-To: <20120510190554.6055315139a68ef0b1c48261@canb.auug.org.au>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pz0BBB9QxoYXlT+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 10, 2012 at 07:05:54PM +1000, Stephen Rothwell wrote:
> On Thu, 10 May 2012 09:53:55 +0100 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > That's the right fix - it's already included in the regmap tree itself.

> Yeah, this conflict arises because there a set of patches in the
> sound-asoc tree that are also in the regmap tree.   They really should
> have been in a stable branch of the regmap tree that both trees could
> merge.

There is (if you look at the -next branch in regmap you can see it
getting merged), I just didn't merge it into ASoC since Linus was saying
he's going to do another -rc and he complains if you merge bugfixes
directly up into your development branches too much.

--Pz0BBB9QxoYXlT+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPq4wrAAoJEBus8iNuMP3dPl0P/2r/wJWVB8Cl3bIxbT0IVyHU
U6bUBQENIvMPwIW0/62mTt9OE2fDVRDxtLSZTDrTLovGYb9tVgDVz6OtJAIsnzpu
Hmo+8+bDiuHGEp5obM2kSVFU3zRw5F2SnDqrrwucJzjkIyyu6pNUK2GkzJSMcQOE
a6JsoZxobIi3Nix5m61524NqX/gsaMEWX3J+KCa67vCuB6Yui1+P6lBWapiFl4Y0
GEVzSxAQ2vvV6+ZD7UGE9CH1s7HDcar4ST1K8l2Fkfqb8Rs/oFF6NgnoNoMURO9+
JDFM418FqySJ5TYi+cMbQZCD27vty5J9VorPwsBS5XzYqnUea7Cfzjut48kA31Gr
BdNTwy3E92cXejrIgfOYeDiUMiZVxA7zijB/C9CtWXKkVHFFlkl8Ipc6GzzIamGG
BOmGyGtxex8R0oUNaFmM8CTvpcfhvXDwVZfPwz9SDinN0Q+9qrp6Vzc3QjqDZIkp
nWPMMg4xKUrg7ZvPWKAyKlHTJTXH5P4gE69ZNZhT7gQfgh8gCgODowLrswEN25Pg
K9/Pu6qN43K2WYO4QwyOQDteix7CI05OxwDq95qNUpP4W6WfCwmvWDRgSBe4hOhw
zg+QURVWC793dRq9QjouTkJtFLeuM4aPvxuqsT1eJjx9I7CeHTGGqmQoE2fucEkK
grCY4AY1Z4nJdwnb/bw7
=YWwY
-----END PGP SIGNATURE-----

--Pz0BBB9QxoYXlT+x--
