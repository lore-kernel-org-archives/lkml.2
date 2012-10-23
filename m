Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2JWFdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:33:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:27007 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab2JWFda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,633,1344236400"; 
   d="asc'?scan'208";a="238852954"
Message-ID: <1350969806.2135.16.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH] RX initialization sequence fixed - enable
 RX after corresponding ring initialization only
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Richard Davies <richard.davies@elastichosts.com>
Cc: Dmitry Fleytman <dmitry@daynix.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>
Date: Mon, 22 Oct 2012 22:23:26 -0700
In-Reply-To: <20121019191944.GA27699@alpha.arachsys.com>
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
	 <1350235151-11146-2-git-send-email-dmitry@daynix.com>
	 <1350280341.2152.12.camel@jtkirshe-mobl>
	 <20121019191944.GA27699@alpha.arachsys.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PbX70A7MzzsTVldyQuBo"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PbX70A7MzzsTVldyQuBo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-10-19 at 20:19 +0100, Richard Davies wrote:
> Jeff Kirsher wrote:
> > Dmitry Fleytman wrote:
> > > Reported-by: Chris Webb <chris.webb@elastichosts.com>
> > > Reported-by: Richard Davies <richard.davies@elastichosts.com>
> > >
> > > Signed-off-by: Dmitry Fleytman <dmitry@daynix.com>
> > > ---
> > >  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
> > >  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18
> > > ++++++++++++++++--
> > >  2 files changed, 21 insertions(+), 6 deletions(-)=20
> >
> > I will add it to my queue.  Thanks!
>=20
> Hi Jeff,
>=20
> I hope it was already clear from the following discussion - this patch
> turned out to be a qemu-kvm bug and you do not need to apply it.
>=20
> Dmitry - please confirm.
>=20
> Richard.

I have dropped the patch from my queue, thanks guys!

--=-PbX70A7MzzsTVldyQuBo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQhinOAAoJEOVv75VaS+3OTbEP/iLyy68vnOuZqXqsPq8aJmxT
DeDdklc/gKhEZP3MS7FBxGIolprWHKMhVRo0yI1FlZ707yCgJLGqXiuudhJVkIk1
HFVqTZLxX+hxQ9TkiUIyDKNlJR47FKJgdITNxZr/ISR0dTerpUSvj/Kfe3jnzMBl
fCZllINXN5zTildCMqXG2FoDXVpObLbUa9ACWZ9PLfpomz2U0iwNWRc543FPOuz+
y2SNiQ4XmKlphwCws6rCbj1nIe4qV1pdNLgpCxcKBoejEvvgUIROEZ629Vr2Sgjc
qLi7bB1eV5irD1HYdy/niDN/R0JSohwcC60F1rdkM+i0MSwCVQsrN6mqgRJ58L6F
n/BxhlRShrovHcXgwC/yVrPRTdSt0ZepevbCx9cXuOJoiOM4II8rmNvmhXqa1q7L
T+RKornmo8EGURzhqBohgGlzc7JHeQNiVQRY7GhTOsDQ1xYLHpMOyl+GagD9UCbf
LxEXpXZavuO1J6Tk/TT2PaBq8XnXT1et3kwsZ5Fp+0uY+KSaDpOJiNAbT5qiyMHj
qiFFs0Sjd3rMoHMDqFmemuHSMzY5ngxSLUbPfJZkGozH3PrRmEfS8muu07OhH/GN
UEl3idOg2fey3Ixwxtp1IBTVxBqVyefrNbUj0s9MX32bt9Z40ViXgt9WbCCV7oSF
b5NppX6soZ+OBXJHz/UX
=KSwm
-----END PGP SIGNATURE-----

--=-PbX70A7MzzsTVldyQuBo--

