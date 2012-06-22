Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2FVJMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:12:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38413 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932395Ab2FVJMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:12:44 -0400
Date: Fri, 22 Jun 2012 10:12:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, Laxman Dewangan <ldewangan@nvidia.com>,
        lee.jones@linaro.org, lrg@ti.com,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120622091238.GF4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
 <20120620194609.GA4037@opensource.wolfsonmicro.com>
 <20120622061314.GA15627@avionic-0098.adnet.avionic-design.de>
 <20120622084228.GD4037@opensource.wolfsonmicro.com>
 <20120622085909.GA24121@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GLa4d69Ev2s1FDzP"
Content-Disposition: inline
In-Reply-To: <20120622085909.GA24121@avionic-0098.mockup.avionic-design.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GLa4d69Ev2s1FDzP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 22, 2012 at 10:59:09AM +0200, Thierry Reding wrote:
> On Fri, Jun 22, 2012 at 09:42:29AM +0100, Mark Brown wrote:

> > We're talking about consumers here, not the regulator driver finding its
> > own regulators.

> No we're not. of_regulator_match() isn't used by consumers but by
> regulator drivers to parse the DT.

This subthread has wandered off the topic of the original patch somewhat
though.

--GLa4d69Ev2s1FDzP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP5Db7AAoJEBus8iNuMP3dXK8P/2IlhIvWiL12zSg7LLMF8Rpb
RvPy1Af5U0h2iG7aGVadiUIG+HzEwRqDCWvolrrtj+/ofPtxFyDGirtdUbH9S6MR
T/TzlkFy4YOcaJgQ+49vKUd4RcQfHB1oYdDbEkxlXyK6CRlWqriKseJ6KpvZh2mc
IAmkdMgjVRVAFVRCtkIoWtaAN6vWM5Il9A5oB02gnCp7iMuCOjmqTHPKgISsi/Ft
xP+2FsTp0gIjcguU1kYOMwLMp+KmSOpUSoeYdJOJyOX++1Y0ngVxoQVPDcrzUjEx
3dcGvbi9TIQF4l43iIQdBZGgq2eaNIAy6ZjHkNG3IpcTxLgz+b/mbuWRuNuWqw7D
Ggz0Ks5yW46yeK9rfdaCyb2wgsFI3M492T7baicFok+RfZwlIToYHAhgk5ncWdfD
cd7lP3mkAkbF0XyHjnHVUgkgYp4RjDPW07YpLMYCNKRLsd6LHCNnro/2KZMgdjpF
h0udxw2GAaBcHjWUD5qe0dlj+wauS2gRH0R+0eAXpguMED6bKplKkmb2hm4vSde5
PAFe7JmmdEbJs0LGYfOtSpNRDkTRyV/GiX0JZPHom/sztlTpem4CdDU1yRaFymTw
MCf8+IR9IAdoXCNQ1rsXFd7t7I069KgPUkVflrjEcJQzbdHmNYJ7T6WIkOl1nmFu
4DSCI47S49hlAJYzDOre
=NXef
-----END PGP SIGNATURE-----

--GLa4d69Ev2s1FDzP--
