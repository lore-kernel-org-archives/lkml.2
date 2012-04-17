Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2DQNzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:55:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60964 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932243Ab2DQNzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:55:20 -0400
Date: Tue, 17 Apr 2012 14:55:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (regulator tree related)
Message-ID: <20120417135516.GF6652@opensource.wolfsonmicro.com>
References: <20120417142748.d42daa09958086a6e2ab4878@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GLp9dJVi+aaipsRk"
Content-Disposition: inline
In-Reply-To: <20120417142748.d42daa09958086a6e2ab4878@canb.auug.org.au>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GLp9dJVi+aaipsRk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 02:27:48PM +1000, Stephen Rothwell wrote:

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:

> drivers/misc/max8997-muic.c: In function 'max8997_muic_irq_work':
> drivers/misc/max8997-muic.c:313:34: error: 'struct max8997_platform_data' has no member named 'irq_base'
> drivers/misc/max8997-muic.c: In function 'max8997_muic_probe':
> drivers/misc/max8997-muic.c:434:35: error: 'struct max8997_platform_data' has no member named 'irq_base'
> drivers/misc/max8997-muic.c: In function 'max8997_muic_remove':
> drivers/misc/max8997-muic.c:474:17: error: 'struct max8997_platform_data' has no member named 'irq_base'

> Caused by commit 98d8618af377 ("mfd: add irq domain support for max8997
> interrupts").

> I have reverted that commit for today.

I've just reverted it, Thomas please submit a fixed version along with
the regulator patch.

--GLp9dJVi+aaipsRk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjXYjAAoJEBus8iNuMP3dRKwQAIsoH8mL4C+HvA0dPym3zTIJ
hVslN8+DK40/kHlPAJQbsLH2JHq/P7od2nw4talo/U0Mb83O2wGN/Cpg+UgHMDFv
zLaAJClk4uRpRcsj3NElqRkYvmBftw/RAKAjDE0v+OLjTJEF01HM7Xrqn3HRfFDV
Gz4xdQN5XrAU1qIr9wF/pdhwAjioATe3IoFGfFQd4egsFnTKiiDWK8FIplNk1Cwh
mryHYyKxC4sXm84lUVkB104r1C5KXs0SQ+EMAi9OhgxyrJCfXlcNUyTT8tFXvhc1
0zCzJOFk3QAGa9MnezTH4j5kK/iBWYMEAJb+TsYNL0aUUxxtE8k21dzK+KPOzAyG
ZzYAtMElAdLPRpaEGxs2E1Wx7w5oW+swT3W5+SVnnScGh6aXW/ER/PRSqXA6ywrI
SB5SFZMdPcAgdo08X/7GTwKvMvqeeHWl52Ms0WcbFIJ2ICsNcCO+TLn9xxsjfXrK
qwM+mK4C+9oyRgNedv6hSqBE5keMXbP4mNdAfkfTFisKK8N7PryRgNm/JrfdBJHx
t2Vfc6uaz1P6NX7HAJ+egfNwXQSDCpXt0jmnQeh1Zp/lbvtgD5jgymCosQUyQfwX
tlFIBj0gIwDMpWUYueC5YWSEzTG433Fw6+zxGpEWDFjLEQJQLzbUDDV494ZSyN40
17q3Y3f6Llbd/RW9wPZz
=rA/h
-----END PGP SIGNATURE-----

--GLp9dJVi+aaipsRk--
