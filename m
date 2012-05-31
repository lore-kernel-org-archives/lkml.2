Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab2EaNLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:11:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40159 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757496Ab2EaNLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:11:08 -0400
Date: Thu, 31 May 2012 14:11:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531131106.GF2666@opensource.wolfsonmicro.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
 <20120531085432.GK5377@arwen.pp.htv.fi>
 <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
 <4FC768F8.4050406@ti.com>
 <20120531130456.GB15786@sirena.org.uk>
 <4FC76D29.8070802@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yH1ZJFh+qWm+VodA"
Content-Disposition: inline
In-Reply-To: <4FC76D29.8070802@ti.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yH1ZJFh+qWm+VodA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 31, 2012 at 03:07:53PM +0200, Cousson, Benoit wrote:
> On 5/31/2012 3:04 PM, Mark Brown wrote:
> >On Thu, May 31, 2012 at 02:50:00PM +0200, Cousson, Benoit wrote:

> >>It looks to me that this kind of function does belong to the device
> >>more than to the clock node.

> >This is looking a lot like what power domains do to me...

> Do you mean the reset part?

Yes, the general "this block goes into an idle state and so we need to
rebuild/reset the state of the things in it afterwards" thing.

--yH1ZJFh+qWm+VodA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx23kAAoJEBus8iNuMP3dj3gP/iMMaZg7iVUDFtZs5utM3y4W
Ew/O6UhqLGgqX5BoctZ93YTZg1YwNLC8QF1Ilr8YKfaYR8f/c3JemDgKyL+V0+qS
rG9Pek+rTwO1c2aAaVW9FnWLt56FNQmZJxnmv/0BDDaqykm7QBcxh+dFy9OZCAgm
UKGDdVB0n/nxuO3wz8xz+2S/bfgdbtFqfPGmaOSt1Z0rr6uJ4Av2lY1XckfALhc3
XsAan84Wq3yeCqAILdxMZXjXAD7VWIwZNRp0n/mYiwleJ+AjCUNoSmjhM1gKnJsF
3xIQtY5EG+BuvCoxf9/CMyVGP4kM8FDeYDPLbeQfqGnqyRD6KWzp4bucMJlt7Zlw
enwzJbyDN29OLGnfaTYNmNPc509byn+QvLtAvB0e2Yw3BogKen5l9duBov28ztIt
/3SkRVOZcB/LS0C8E+cwaEtVuewoHei1SXqut6Z7QfvRJi+lM1pGAfLg2P1WFN1l
M0pll48RbRn8vy3wrmxpNhOdMtuzrYlhCRmeqDgFc1lZxmJ6q2XNLtPHjCDQ2KWv
WwjilBOrb1jCw2CIOH7VpnANxgPHbWspbe5JgOjUaTobqHxgBQvY3jG4Uf2LW3lu
4MQ7/oteIb5E8tlHM+lGm9yHZL0GspUWQ9ED5/QGJLnMkM2r/gcBY7RLsGBk+g6Z
3IZCDwugl2r6fIbA1K2B
=kO5I
-----END PGP SIGNATURE-----

--yH1ZJFh+qWm+VodA--
