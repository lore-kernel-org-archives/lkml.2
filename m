Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2EGLfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:35:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59784 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194Ab2EGLfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:35:32 -0400
Date: Mon, 7 May 2012 12:35:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] regulator: fixed: dt: add property for gpio open
 drain flag
Message-ID: <20120507113528.GK4415@opensource.wolfsonmicro.com>
References: <1336386499-20408-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="++alDQ2ROsODg1x+"
Content-Disposition: inline
In-Reply-To: <1336386499-20408-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--++alDQ2ROsODg1x+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 03:58:19PM +0530, Laxman Dewangan wrote:
> Add property for the gpio flag open drain when registering
> fixed regulator.

Applied, thanks.

There's no need to put stuff like "v1" in your patch description, it can
sometimes be useful to do this if it's a revision of a previous patch
but if it's the first version it's not adding anything.

--++alDQ2ROsODg1x+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp7LXAAoJEBus8iNuMP3dmAEQAIbdANv6697lMCgE+1U77e2/
BnaWlVCveLPlxgIBt0Zm7yP1MKeoaMSE9dIZp5vdtCxEUOh4JtBdDVJ873KhuiYp
tvHS4GmNfptd0mgA68A7OKu+Dtjum+3dGJi8SoE8QeFWbb7cl7unh32CEhqujMe0
0Ea06uaNmhkPLIaOVExRqyimzpPPLMc46FLVQ2j60caq98dFxwaOsqhs3aIXt3aB
r/r1uU49CY/UcBnW9YHfe8wpw7S5IXeWQTDy65Y9b2gRQfmKdF2/bHNAmnHVBh/k
aBGMxv2P9Nc/aObo8ouE+rQqdmPK2gWkPAaYsP4y4EcK3ZKrl2jNUzRGPtWsCfUV
oJw0JQm+wflHhjz5c6HaidncaFrieBileBSqGDsO0Wrh0FIk1kHsQkJviK+vpbj0
3WrwsTtcXglaR/lPgTrl0Tj0nMH1yy4pBGEceyvbOZ6dfo5tnn9OBC1TZlLY61FK
BUF99AoGpsDhhOdoGgTqa/XmSBHxkydy+B8Dj2gP8diWBCE48B8hMNm0GxTL9IZT
4c44bl3i6RuHq+a6fzdYcM5c/SRTFx/b+jp9BswKAgcP8c4OqNTU/6BgANIVPwaH
5jZG0Raj3qxfLcCj49a4pRp7k1WbSuPP8slxk8V3XQT6jw5PMeLnDUtKPUeD8tr0
IIQNkVV0e6QJZ03m7h9h
=ZAKn
-----END PGP SIGNATURE-----

--++alDQ2ROsODg1x+--
