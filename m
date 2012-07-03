Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab2GCTZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:25:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53819 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab2GCTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:25:10 -0400
Date: Tue, 3 Jul 2012 20:25:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        arnd@arndb.de, linus.walleij@linaro.org, lee.jones@linaro.org,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] regulator: dt: add policy to have property
 "regulator-compatible"
Message-ID: <20120703192508.GG29030@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <1340194987-23654-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vK3aNhhOnFYnG5nq"
Content-Disposition: inline
In-Reply-To: <1340194987-23654-4-git-send-email-ldewangan@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vK3aNhhOnFYnG5nq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 05:53:07PM +0530, Laxman Dewangan wrote:
> Add the policy for regulator DT such that if device have multiple
> regulator and its binding contains a child node that describes each
> regulator then each regulator child node must have the property
> "regulator-compatible" which matches with regulator name of their
> hardware counterparts.

I tried to apply this but both git and patch are upset with the patch at
the line:

diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt

for reasons I'm not immediately able to discern.  Can you please look
into this?

--vK3aNhhOnFYnG5nq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP80cDAAoJEBus8iNuMP3dujgQAILrpi7J3IzRbtEvzHCOtt+l
Lcu13Wxy0etDIqaigDm3L/UQh6zKdV7IzuCL7CAg3bn2KtxYUBlfSiOIHLzoK+m6
wEyxIDe66oQ2KK7CpZAf/CJA7YrBuY+oxcKy3VQoDOFUHWQ/hAIGNkEMZuvrV/m1
F6NFNujeh1allh2uQDXlDYqa6W1D7ptPGWOLxU89E9PD7aaYhovNa1EULKhQLyQO
rrUY/0GE5tJNhDFtQQdFrxL0eVapyYTiMu+bXDfK2/cr//O9Uq0geolCgQAA0ldF
kBo2BhrsX6+9/qseQig4QSwYe78p8pWWFFdO35TH6gFYwQ4BXIoKsJ49KsDyt9Nq
AtaugnC5bJEKhpYn7aGniu60j/S0scoECQf24bz+dK1EQQsgByc3kAqPnEYvAZ86
S0LV9XxkuaNiPbmGQy67EPn4glumM4rsujDcBcjAdnSNTIbMO9QCm2p67/x3XT1W
WF2btN1Uy2M41PLxRazkjAyzSoD08rMDHeTmUCMLe6YonopJTpaTK9Jmgy3tk4r4
9Iq4EDgfGTeUNoV3px/kfxisg4zFq22NrOmcP/hwh0mpIz4Nwhv8oHqYe8mcR5Vz
SUVqCIStaPzpILajPGvJVF+BmLdURVdmbnU6j3zy6+8gQbn1EykLxdjX+678m+5C
R5LLfCpoD8y+XikUFr3y
=LvKC
-----END PGP SIGNATURE-----

--vK3aNhhOnFYnG5nq--
