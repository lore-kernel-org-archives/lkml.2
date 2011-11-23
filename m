Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1KWR1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:27:10 -0500
Received: from comu.ring0.de ([46.4.151.82]:51562 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1KWR1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:27:08 -0500
X-Spam-Report: * -2.6 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.1 AWL AWL: From: address is in the auto white-list
Date: Wed, 23 Nov 2011 18:26:50 +0100
From: Sebastian Reichel <sre@debian.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Carlos Chinea <carlos.chinea@nokia.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>
Subject: Re: HSI framework for linux-next
Message-ID: <20111123172650.GA1637@earth.universe>
References: <1319794066.28874.22.camel@groo>
 <20111109085140.908f89d0e2b8160cc959d67c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20111109085140.908f89d0e2b8160cc959d67c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 09, 2011 at 08:51:40AM +1100, Stephen Rothwell wrote:
> Hi Carlos,
>=20
> On Fri, 28 Oct 2011 12:27:46 +0300 Carlos Chinea <carlos.chinea@nokia.com=
> wrote:
> > ...
>=20
> Right, so -rc1 has been released so I can consider this.  Just a couple o=
f things:
>=20
> 	Linus (and the rest of us) is being a bit nmore paranoid about
> where to fetch trees from.  Public git hosters (like gitorious) can be
> problematic since it is hard for us to verify the owners of trees
> reliably.  You either need to apply for a kernel.org account, or you will
> need to add a signed tag to your tree before asking Linus to pull from
> it.  And that atg will have to be singned with a GPG key that can be
> verified by Linus ...
>=20
> 	I am not sure how to translate that gitorious URI above into a
> simple, publically fetchable URI (git://gitorious.org...).

It has been two weeks. Did I miss any status updates?

Here's the git fetchable URI: git://gitorious.org/kernel-hsi/kernel-hsi.git
The existing tag is not signed though.

-- Sebastian

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzSzaAAoJENju1/PIO/qaY0MQAKiu224IuEZOOthosK4C9yiH
roveCT1XnFSQc9csLVuH3T3Z+mzqAQUO24EmureQGSkeiHlG5YEyWFhsIPzdaDme
vKGRuOttsyaQI39FnuCnbFjh+2PNmFXSXnhnZ8KfW9hFFVf/ByLYcidsHvsioIEc
X6fZ7j85U2O7Od+jDK8t/uYuvk3BW0z8JEYAIP/KiV51TjYQ695WQ4LUTM6BHf7j
OMhuUTNtpUyHYZC1qAvJzxQB9M1RDUqrxzjqT+XQeEXPOu8UdFYcCq5kZNdJx2P+
1irrurBqovMBonYP9viTyat1yqQkIU6tUTmp2OLQG2NjKzWrDt3ms931GndI2bEM
WEkwhLRMT3ZtLaPsVbtjS1Rh1TPnsdr9l16yQse2M7HJxgBAsLNf0/5Uy0cpO/Bi
hlIcIb/kTSdHmHcBUVJrAh6c2hwH/tgDlZwhQc+aURoPV0o2VDKUr88zSSETsvUa
FwMtMZK8evCEhN6Ga5vBYA7K/X7APvzkvX97wDrunqSAlYGsZmIDb1BNDiSa5zxo
eKR8g9Ajpsk4EPfmUSS6I5OAnZP+bapahIO9Y5StoOaC5AmX1r6mo07IxaEykIns
H28K8/90UiVvIXDL5zcBpN3GCSZiQUTMxFuKQXauGbZ2sdPpZjEMYeQdt29+bnwQ
yPMllaeV9XQpvl90wRa7
=VpEa
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
