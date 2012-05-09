Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab2EIPLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:11:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48731 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759564Ab2EIPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:11:36 -0400
Date: Wed, 9 May 2012 16:11:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mfd: tps65910: convert all allocation to devm_*
Message-ID: <20120509151131.GZ3955@opensource.wolfsonmicro.com>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
 <1336569057-3890-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oRWDw5wXQ3uCJU7V"
Content-Disposition: inline
In-Reply-To: <1336569057-3890-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oRWDw5wXQ3uCJU7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2012 at 06:40:55PM +0530, Laxman Dewangan wrote:
> Convert memory allocation and regmap initialization to
> use devm_* functions.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--oRWDw5wXQ3uCJU7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqoVoAAoJEBus8iNuMP3d4XIP/iK78QZUPoaNJ15MiLHPrkEd
3Y/adGgRpKl0JcF2xTkFa8TU6E60lkjbqeF1K+c0+JPFnlcHRe8Us7ow/sFS7hA2
YQpbi9rT4U2TdWq3/XrL7CstYg+QD3ODfFVho5BBLbmn6HcdGoterBW0XWHnTT+c
NJ8AXMKnFsF5BQev4r+JkqpQjqeurj5KEYAghIDiXRKsOuWhNlBS6Y3cpC4HZcZL
JMoVzt9OFqd3anVEoeUaqq1Q6vjluqsYkhN28QakWzQu2bGV51KqDOuBb9LG6h3I
RnMDnsC7ta+UyIoBHcKZLBoyREs8I2fDHgI0Mgrq4L5IVzDjQTAzPQl1J4atorW4
n/AXU4luFwydxsXGWMJBVX+jGg+PwMSVC3j5//A7okMB3kv4usXAfOgF/mrOEkbd
nPPQ9hcF4Z9HrtvPkrIOq/e+uGmCqLtKnDChCNOgVjOJHACOvspsxt/t41MG6DaM
DA9GgbvryJjYJQh9fiWdtbvd5DqS/2HILcW8uU5FrlKjORnhAPqVnn96AfCVaBXQ
uz5T1tW2gDi4IPf6ot/Sjc3Uou3qFvEI/zPUTRXN8yJ/4jtVwDyf/IHCA5t752jN
siLdEBgIRypaMK67xfmVJb0aG9ePoxSl5W/2QpClG6E9G8ifaJ+270crY01yVc5L
pwum+PWT/Y0t8h39WhNd
=vQQE
-----END PGP SIGNATURE-----

--oRWDw5wXQ3uCJU7V--
