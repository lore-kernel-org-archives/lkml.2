Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2DIRxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:53:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41636 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab2DIRxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:53:47 -0400
Date: Mon, 9 Apr 2012 18:53:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regmap: implement register striding
Message-ID: <20120409175343.GG3182@opensource.wolfsonmicro.com>
References: <1333748199-7123-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ls2Gy6y7jbHLe9Od"
Content-Disposition: inline
In-Reply-To: <1333748199-7123-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ls2Gy6y7jbHLe9Od
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 06, 2012 at 03:36:39PM -0600, Stephen Warren wrote:

> Note: I wasn't able to test REGCACHE_COMPRESSED on my hardware, nor test
> regmap-irq.c

You should just be able to change some driver to use it for testing.

>  	map->reg_shift = config->pad_bits % 8;
> +	map->reg_stride = config->reg_stride ?: 1;

If I wanted to code in Perl I'd be working on another project...  write
what you mean please.

--Ls2Gy6y7jbHLe9Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPgyIXAAoJEBus8iNuMP3dquIP/1hRkW0xqDwTmKMXp6uPwk9E
7SVcBiUqAO2gkgXoGkgDnp2kib6WtG/CG0yvhfesDPvwlYxUH5Msd988hbtqoo2P
xbdwsIjFrR7PouBJLzQDpiRCTwLqBzvAX8e2+hu9514QAlIJDPzl+rCoVAJ3tsgE
8jhjWhrkf721yORL8/JMIfHXPzI99Bv0/ny05PdSR7tANhZOf+4rqeP/9YU29HR4
7+ss9uqwxf2GUmiESj7EZ4fBkAQZy2q9wqYBrTpnw9GYS6swKW9ePfkf3eJ04Csi
S2cmZqpiOTkxwJBd+PeesGJsCIPMkQb9WJz6IwGms5p3CfF8x7OkxG6mo/lT9TRK
k8Dq5dMbTOcgWUzRtpTif6qhlm6x/iKdH6hZxK7z0rq7YAwFt0+NZiASSlW9gvfa
s+SiTWo5puODpZ8YV6pQj4uqiyZ4hfwPBiz3nglGYUkkazIMx+OJY7IWuexJAsTy
57EM8GV7Erfu2AQtdJCOMQup+Q9i9WkcWNsPIKXjhcdOEDO3zxXlMPUHWtp+qPjS
juoVNWRXwXxnW0g2kTvxAqtgV5DdR0Ss2PRr/V/t3/+7RzSfoLuZ7JZKIjrJBADr
7JMrLT25T+O8Muo8GaqpImtN5Wxen3FBqlt1Tj35dNe/6tpbkVEx6uWfqNDlJxJc
G5D0Gak3lkr7BLgkdhs8
=L1hE
-----END PGP SIGNATURE-----

--Ls2Gy6y7jbHLe9Od--
