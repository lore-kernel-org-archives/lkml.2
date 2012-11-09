Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2KISi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:38:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2KISiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:38:25 -0500
Date: Fri, 9 Nov 2012 19:38:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: tamonten: Add temperature sensor support
Message-ID: <20121109183819.GA7663@avionic-0098.mockup.avionic-design.de>
References: <1352466474-27581-1-git-send-email-thierry.reding@avionic-design.de>
 <509D3CD0.4070006@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <509D3CD0.4070006@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:INbMrlDq7k/IGlVOeL1RIiFmTCaFoEz+ywSmZ2gNTBD
 wpsvv3P/ThupAyRl5t7JIe2M2LTMQzm+3ih7Fd6rnnyWx0636x
 wrCRAVo3bwQT79/5h0CbDJJ7zLDzYu/5/mpYkDcwSjp/ga/2XI
 58+gFUcUKXUtdAmnr/DP4Roy6Zc9wKge72t5CNylt071Yy5E5t
 rq/3d67/FC9GJO/tX5n6rf2DIXyLLJp3exCt2WTOkGaioC+npe
 a5FDCvD5X1ytf9Fd000P0aCfJ3ipyaoPkddIEl9yH5Bok6DAYp
 CfHdxj8ZqKqgvr/R/1SmyGr7hZBGpbauoqW2Fm4N32wl9A8hdW
 /BdK1e8pAHdt/rga6KzDDxyDTWaurZmksdmIJSNYSstn812gkK
 tzN/PSxBr5Ws+XmSqO+p6m0GaAhLhFUibe/bdTrSaL/86josga
 wI2vm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 10:26:40AM -0700, Stephen Warren wrote:
> On 11/09/2012 06:07 AM, Thierry Reding wrote:
> > The Tamonten SOM has an ON Semiconductor NCT1008 connected to the DVC
> > bus which is used to measure the ambient (local) temperature as well as
> > the on-die (remote) temperature.
>=20
> > diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dt=
s/tegra20-tamonten.dtsi
>=20
> > +		nct1008@4c {
>=20
> Given nodes are typically named after object type, should that be:
>=20
> 		temperature-sensor@4c {
>=20
> as it is on Seaboard?

I'll do that.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnU2bAAoJEN0jrNd/PrOh+KgP/11QZcVdS3bz2R2CIPg95HcZ
aI4IVuAj6mu+LgrugWfWcVcPdkVFCA+D9l96SfPmWT47zBwmawg9QmSF94pw4lnR
aw0V0ot8aJPfSughOT1M177jl8D87ShLM+ZgBOWOXkoeXOcNYE4kPhhIbkIouxrO
mX16abxe4gvP3kvZPTjlM132X6XxMhDSHpbMvLMpEsrAAcSRPiy27K0575pPYPQ+
4Ca3g4LuPGBtASf5nRJTXqs1RTiJmhLuJPnrplXRhVXDhmcb4esoadDJTbv24dKk
iFn6zRDXUjN6Gvc5Xz6RXWjSI2Kn4jT3HC7wwTp+XWu58A2gT93KaxgG7dFef0Q2
4QjXB2r27tdRv4+EX15tEYOvntU0AzrcOC0lC3MhVX0Bl6GhLsuHmX+SfLP5kI8n
VezfqRcea6alyXJOS0KXuKFO0pfTqFwDR7/ek+5wiYjIs9qq9JEm7yL4j9etHBuM
lxa8fg0uHIrlAuY4slYgh2PmBea4NMgbOkU4ymUogh3om0x8nV2To1migaw7X0Jb
dqJ+dJISsI+2LrvDXauh/uoiGoZtkDXKLO+/2c/v5tPkwoistFcbZHjJgQFUMfqW
q6RWWlDaHAy3V1GmqcFGSCC7XmNqo/d+UWwXwy+EDZUu/90E9GX7sPTmftEpVmpE
Wl6zBkKcIj+03LFy0hE8
=Vf4/
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
