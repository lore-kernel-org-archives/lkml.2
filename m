Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2FRR2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:28:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39050 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992Ab2FRR2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:28:11 -0400
Date: Mon, 18 Jun 2012 18:28:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2 v2] regulator: support multiple dummy fixed regulators
Message-ID: <20120618172808.GX3974@opensource.wolfsonmicro.com>
References: <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
 <20120618162058.GT3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181826210.23884@axis700.grange>
 <20120618163758.GU3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181850280.23884@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MTFjS3R2zZZVGaSB"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206181850280.23884@axis700.grange>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MTFjS3R2zZZVGaSB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 07:13:06PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 18 Jun 2012, Mark Brown wrote:

> > It's for cases where people can't be bothered to specify the supply
> > properly but want to just put something in there to satisfy the sofware
> > without providing any useful information.  There will be one or more
> > physical supplies but the software is being non-committal about them.

> Ok, but for that purpose I thought we already have the dummy regulator...=
=20

The dummy regulator isn't supposed to be used in production whereas this
is - dummy will get substituted in for *any* missing supply as a crutch
to get things working while this is added where needed.  Having dummy on
can break things.

> So, what's the proper way to describe board common voltage rails?=20

Fixed voltage regulators should be described with the fixed voltage
regulator driver.

> Obviously you don't want to disable and enable them. Of course, there are=
=20
> real physical regulators, that provide that voltage, but what does it=20
> change, whether we specify the real name of that device or just say - yes=
,=20
> we have 3.3V on this board? So, it IS just a fixed regulator with a fixed=
=20
> voltage with no way to control it. The only action you can perform with i=
t=20
> is query the voltage.

The name is mainly useful for allowing people to associate the code with
the schematic, by putting the name used in the schematic into the code
we make things much easier when people want to map between the two.

> > Meh, yes.  I did try to make them readable.  But then making up the
> > names in this fashion does rather defeat the point there...

> Ok, what shall we do with this? You want the user to supply a name for=20
> these fixed voltage always-on regulators? Or you're against these changes=
=20

Supply a name I think, the use case is totally sensible so it's
definitely totally reasonable to do something.

--MTFjS3R2zZZVGaSB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP32TvAAoJEBus8iNuMP3dPwMP/Aouhyuckh9at1/RhO2EC3Dm
ntf8CHxR7va+HkAn1nzdHAJF5DWXxUSxXh1W+b2+fjrd2bUVbm5XAjhrBirKdD05
FUc2HFZ2u+YC+y9WVOOPEEama7Y/Wt11FLectJzBPNjRHOVlf71BM2deGVlj6K3l
TYBOxDj+K+cLuJcga3evkc1tksRMCT21vncLTDyYXG/CANH0LtgZW2JiL6vmbVSF
OwjAZzm/KOOAmOOdu+SAqa8fka2FH3lUPWzUd5uJKaZUVCK5zKBe1Fjvkj/gRNMW
6STG8eYFmfgZKrvQsAxC1ubyZaGfgA+F2/BlGOmKH2UQzaRl3qSjTI44dddMA1aV
nY/KIbOozrjlyGmfKMzk9ajVLmD3nVqYa2SSBSlji7K7dzrenkim7cJ79+18ympy
U7aH/ZH9O/sNAwz6m/daBzY3DZzvlUPzh73WmAY/M+m7FM51A+QTXiLlQxpKAxpI
FylP7jBCKC2lIrGFjcxpKXHStqQFKz8UaNDqP445Jnh86iIvg6KRBvp3rviPV8ux
FhYNnqI2arSUgpqgLEBDig3vDcRkZ2JaBJOYuMrb8wmOs/ptYxtm3AnT3uwH3/pg
Z5My2WdJkfH+F7KwT/FovioW3OI6nhtYzNLAc6Yr5L4mY/mXwHCQPMRcRz/L58pV
AH/jO4fdPhPolQc/Htnx
=fNtG
-----END PGP SIGNATURE-----

--MTFjS3R2zZZVGaSB--
