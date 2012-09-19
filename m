Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2ISHSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:18:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2ISHSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:18:43 -0400
Date: Wed, 19 Sep 2012 09:18:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] gpio: Add Avionic Design N-bit GPIO expander support
Message-ID: <20120919071835.GA7686@avionic-0098.mockup.avionic-design.de>
References: <1347958630-19672-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdY9XK0mN30wk93BFhZ4yZgc-4=Ym5X108OeNQYNrQogQw@mail.gmail.com>
 <20120919054050.GB611@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20120919054050.GB611@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NTHQCoV+wNh3FzwvnHKguyriq+OywgDfa/OyweKs0GZ
 7FbCFxq2GtjyQNPJLRYa8d4HE5I3m0+dtmCRSOSYVWew3blcrf
 rfKtjrpYih+3b6xlZIt+60llGFHCNSJQAztsf5qV9IcUdiLEFw
 X6yz8p3mKx1cTc60E+S9hCxh+oRWehkbfwwqHbfzSQCU37VJkD
 Drr4fniMccf7vjpXcxF9rdmzi86UsiqNkYnOoOjO5sVMNZ8Axu
 ndQH2OM+kzZd95yr8vmt1Yjyrk2AGcKyWoOmZ0Vu370XfA+LcU
 o4z7O8I1RQn5Ath7ui2gs7RlwO1IQFdqnflSpr1TX/oHl6/HJu
 xNGiklhP+ncV/batmw4YZ1emsqIYbmtAgSHeBSt2ECki0m0izx
 SwyvWXjD1ELDO/sjBhJxNvl58N7fRtnfcM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 07:40:50AM +0200, Thierry Reding wrote:
> On Tue, Sep 18, 2012 at 11:29:46PM +0200, Linus Walleij wrote:
> > On Tue, Sep 18, 2012 at 10:57 AM, Thierry Reding
> > <thierry.reding@avionic-design.de> wrote:
> >=20
> > > This commit adds a driver for the Avionic Design N-bit GPIO expander.
> > > The expander provides a variable number of GPIO pins with interrupt
> > > support.
> >=20
> > And you followed up on absolutely everything I commented so how
> > could I resist this patch ... applied with Rob's ACK!
>=20
> There's this one issue that was discussed in the GPIO binding update
> that I posted earlier and I was going to send an updated patch and then
> make this patch reference the documentation but I can just go and do
> that in a follow-up patch as well.

On the other hand it has been suggested that this kind of information
doesn't need to be included in every binding because they belong to the
set of standard properties.

Thierry

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWXHLAAoJEN0jrNd/PrOhZTgP/2zXPMsZrW+xg1FrEYYsT6cQ
rMPWuWX1WIp0pmR7SqoOFUBJSCpqChHS6hMeABRgU/u2TNMdONvTx+R7MY3Q5DRv
5lXi5xDvD+OBNBsC/RMKIw/MlH1NX9g7rN8k+aNBY7oOgrQOFy3OCIE1Cj502pgL
sRfj4r8zP3NapEVfVEV2V7H2ZkydT40EG1V3jr4fgXfeilwFlqAhQfqlWbO7o+DP
QZt5axtOdqLeK61tWzbxnXrRfXRm/kPc1km8Rfvu9smgYBNFspBQFuGLwBpT6DaN
H3u/CTdIpusvFeDDSJn24pWO74fvhh1JE8uRUvRAD7ltc81i64tsXU/GiqvkKlZF
0locBA5K67xZ4WPuXkScQIqRl8c+m5RGvLXIDdjY+TRtaK7pklkq2GgciQqfLWAK
IcPkqeKjRO/61eOas2l4ZmUw/DbHS2L05TyG7RzFECNHVG/heRjPJ/1B+T724rfq
VtrYgEu4nULEr+ExiI5iV87GaOdTnXQG5ixJxnypiIPLCKFsyFBurRT+T1xYa0d7
KhyCEOMwwvVWU24qFP9yQrMZJo8EY77T+nOa+g2pfHecvGTNNXmR6/7tm4oZzbJq
NyD2V6v7VZ85fZux15LdGyyUiBvTExRKn8WCbmbcBDNuX4+0Qs/p1krrrzxc4g8n
ytmBGENq3Rwg8ZfKb2tm
=hpyo
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
