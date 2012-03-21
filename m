Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2CURW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:22:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44745 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125Ab2CURWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:22:25 -0400
Date: Wed, 21 Mar 2012 17:22:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: da7210: Add support for spi regmap
Message-ID: <20120321172222.GI3226@opensource.wolfsonmicro.com>
References: <1332345170.21744.10.camel@matrix>
 <20120321155635.GE3226@opensource.wolfsonmicro.com>
 <1332348080.21744.26.camel@matrix>
 <20120321163811.GH3226@opensource.wolfsonmicro.com>
 <1332349553.21744.33.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3s59FfKcByyGl+j"
Content-Disposition: inline
In-Reply-To: <1332349553.21744.33.camel@matrix>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U3s59FfKcByyGl+j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 10:35:53PM +0530, Ashish Chavan wrote:

> > > Actually I don't have enough details about the problem that you
> > > mentioned with this. I am waiting for inputs from some body else. Can

> > ...and didn't bother asking any questions so it's unlikely anyone will
> > say anything...

> No, actually it's not like that. You mentioned that the sequence should
> be changed, which will fix an issue that the driver has with suspend and
> resume. I asked other users of this driver about the issue and waiting
> for their feedback. I just wanted to have clear picture about the issue
> before I commit any change there. Just to make sure that only changing
> of sequence is enough or some thing extra need to be done.

No, I didn't say that the sequence should be changed.  I said that it
should be implemented using the relevant framework features rather than
being open coded.  The sequence itself is fine from a framework point of
view.

--U3s59FfKcByyGl+j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPag5EAAoJEBus8iNuMP3dj6oQAJazqopx3lcEAHgWS8rm4HNg
tqfQ2i8X4Ego0mvlEv8nqT0n3f1n8HrZBbOzDRN61Shr/j1CiyjrgzaddkggUD0W
KwXnTq/0XHnxSeO2Wg8uYj0NSCiWg4PZ5ieTKvu8xplurasx+tza2V+MEEjiAUiJ
KbtTU3Z5a2+S3cAaefd7k1+ZiQfKFcR6ORd6O2HfypEihUGK0t5rnhO66Rt6Tkms
s3U6Pv/QQoLypf/IALAujzaNzEJ3Czd9kgP9DX7/b8ckvoxAzVsIJu3jua5Rpyuo
jMvbhT/f0hsDDNb01xFCgxAm75ZQmrQNfYoeFEIUjH3WPLjnoznGqjYgfK/3d5z7
AYTssmkxcoUWHzRtXIEvV9ujkj5CfPyiy3FaPIIHHRdM+F1FseW+NWpfS6ktQgOC
ml0wmYTB+8K1ADSk2MrLUmUgMRubxOK4ROeji3aVxZJiHGmSm0kxPscF1TRcRbFP
UckLyAUTlt2706sNLHO9gzd03oDzkB/VKGGuNPz4DPDZlcIF0CcZian/gAIY/4Hv
HMwqdHNdUkhQBLDU2tWUqrv2fxa2kY+vsc7waBiYCzOEKSON23i+BSHBEZm0/cSl
ZtPtR2fDudSnmqYlHWxaHi9IoSL7jmTh6qOrjNE2zZfYSMU4qgfJWvbLDkf1vJG5
r5OLdhgyHZu0XwgdVqEC
=Iyqa
-----END PGP SIGNATURE-----

--U3s59FfKcByyGl+j--
