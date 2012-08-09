Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2HIDZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 23:25:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab2HIDZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 23:25:17 -0400
Date: Thu, 9 Aug 2012 13:24:59 +1000
From: NeilBrown <neilb@suse.de>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Shaohua Li <shli@kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: What happened to TRIM support for raid linear/0/1/10?
Message-ID: <20120809132459.6ed7fc7e@notabene.brown>
In-Reply-To: <alpine.LRH.2.02.1208081308380.30954@praktifix.dwd.de>
References: <alpine.LRH.2.02.1208081308380.30954@praktifix.dwd.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/688z6ejlwP=j3=19nNcKsWm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/688z6ejlwP=j3=19nNcKsWm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Aug 2012 13:10:51 +0000 (GMT) Holger Kiehl <Holger.Kiehl@dwd.de>
wrote:

> Hello,
>=20
> I have been using the patches posted by Shaohua Li on 16th March 2012:
>=20
>     http://lkml.indiana.edu/hypermail/linux/kernel/1203.2/00048.html
>=20
> for several month on a very busy file server (serving 9 million files
> with 5.3 TiB daily) without any problems.
>=20
> Is there any chance that these patches will go into the official kernel?
> Or what is the reason that these patches are no applied?

I'm trying to appear to be an incompetent maintainer so that someone will
offer to take over.  It isn't working yet.  I'm probably scuttling the
attempt just by replying to this email - drat.

>=20
> I have attached the patch set in one big patch for 3.5. Please do not
> use it since I am not sure if it is correct. Shaohua could you please
> take a look if it is correct and maybe post a new one?
>=20
> Personally, I would think that TRIM support MD would be a very good thing.

Probably.  Maybe if they get posted again I'll feel guilty and do something
about them.

One issue that needs to be fixed is that a few places assumed that the
"discard_zeros_data" flag is always set, which is not the case (else we
wouldn't have that flag).  That was only a couple of places though, not a
wide spread problem.

NeilBrown



>=20
> Regards,
> Holger

--Sig_/688z6ejlwP=j3=19nNcKsWm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCMtiznsnt1WYoG5AQIQsRAAoVrPXjJ3Lwwyw0rLveeWZkbJvzy+w2ZE
SXug8NflvEjr5EvoMc8SAEip6xT1lWQo02xC3LAjv78UC7K1ydJbBTci/Ul0EotT
IMA+oBQ327zJEt+O93G9NVZnZEch3dUrYTNDs/o/mms/FQfEVhdmuONc2+5J0zbj
zFWNFFnaNO8NXcV/opvqrMGrF2rTN1Klzpl9hBUk8XFyhlkS+6Sge0VXX8rrLIsE
OSrEUO5om1qWezpoQbubGgNWqUel8w4Vpv/6LDyES8DVTbbCWCHexD/iMz+qeBdt
ZAiidnH3VMrzCaez5qNruYuUbuEPmrddqDWA068KtThW8AkdEK4WUD7oB7u81xI+
pNgQOnT2H+1oEbTn8hc8dXC6Cfhje0kSM904ZmJkBry2w9No6QtTtNFQdRRZJCvp
kwXu71w+LhixQjHQda2jUU/ESz01SqDIw03UrtKITmThx0XXK8+8Vkz564+bf9wn
gPqachCEIv6SurO2WA90HWwutf9tCISbOfr8u1m0l7go+FWbb4WyhwcyXsZVQS4x
5Jbm2OjKHzR4+L8V2eB1wvPMtzFqcqcOA+12+aMn+77+viVAwTBXO3nDlW2Ieq7h
FaYCsWDqk6Wen6y9VJDSdjuhSPbEPryD9jF7HWC7WS4cegSxcNIFNFIqmxEiDEZD
5WkTdVyNa3c=
=TVcV
-----END PGP SIGNATURE-----

--Sig_/688z6ejlwP=j3=19nNcKsWm--
