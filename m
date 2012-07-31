Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2GaJQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:16:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2GaJQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:16:29 -0400
Date: Tue, 31 Jul 2012 11:16:18 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120731091618.GB15557@avionic-0098.adnet.avionic-design.de>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <5016ABDD.5010809@gmail.com>
 <20120730154706.GL4468@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20120730154706.GL4468@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:FQlKsIzEG85kO281QZtK8JJBA02JvXBBdf1zk4NMjgq
 UX36wFEwZBiyqDD+a9mJeoF/u3S0khaCecElFkitHNB6k4czB+
 hwSMioizD64W8aYnr8gBOEEmgxYFp85Koql0Ykm2Ibisr7P7iB
 t1ZYI3EVpT4oEAztezTanDB+6QXtxDXNgIN15UmRorG3ilqFun
 Ood8/OHDhiR0r/GhlSgz15zIJ4y417cIMJaF6/1CioWu9UIIjs
 at2CeoEMp+dM2++/qQFEJzjwC+friM3DGDlWM8VMEEnmsZBM1b
 EaknrKfmZBduCnT4xR3tOXxKL8KiHNO52H53/QJdelX4PYd8Yf
 tUXeH5Y0nOZqRY8A3SML+clNk4qkBuiJbpfWJ07RiZRpHQblbi
 Z39iYQG+TSIz0x75CH4nFXPqM7n7bNJwC0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 30, 2012 at 04:47:06PM +0100, Mark Brown wrote:
> On Mon, Jul 30, 2012 at 10:44:29AM -0500, Rob Herring wrote:
> > On 07/27/2012 07:05 AM, Alexandre Courbot wrote:
>=20
> > > +		power-on-sequence {
> > > +			regulator@0 {
> > > +				id =3D "power";
> > > +				enable;
>=20
> > What do this mean? Isn't this implied for a regulator?
>=20
> I assume you might have some sequences which need some things to be
> turned off for some reason; it at least seems to be something you'd want
> to design for.

Furthermore there is the power-off-sequence equivalent, which you use
for instance when you turn off the panel. Typically they would do the
inverse of the power-on-sequence, so turning off a regulator is
definitiely required.

Thierry

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQF6JiAAoJEN0jrNd/PrOhN58QALwBuu3RhOw7GdcEqzI7luDn
qeYTY2gU2pl6F+NnSiws9VNUoYX387YP/3ocnbV6u7PDRdM6NuXGwLbDGRUHft3z
ohve7zzj0kxD1bG2LTR2qq2/MQFsXPajjEch5eEeobalEyVOsiBp37UxTGFC8+tc
BPpWwACM2ZI8HXgo3sP0YEuSwVxJuUN8UUIpCDWAoRAFkj5iRgRpC9XLf2vr7KeA
uV0Q6P1FlrhfUMS6BXCYPeIVj6mKjg7xOy/602FjGFVJeWlEpKVF40hjcmg8HspX
VeP5KOgtNwk/J/10mZRbHw2TO+zYN13U7bsc6GwnlSJSyrMA7Farb0jDZub5Dcs8
H2dmBx/uTdOiy8S4aLdzfSDDwnqaN3VW854QpYT+JoKZNAEbXAFXMDL4foEkKFLw
r/Ul6E5uxz/D302F3esgzMfbSiBzltI7/o0ZkjfqoBDVTHJH50fuvOkO55xBomW1
t/OlMGZZrXNLkOur4T8dAQHS+X1kzE01BrMnir5lVjzNGnj30G2bS/l7ey7Th4Wn
sfWNX+ELYM4D1qdV3IgS06q+vUlRH0uzY85sIwlA5DTcjWFdHww8IekVl+Qh6FTw
DGm/VmQRJhdBY2mLd3X3PyFPfisfBy9SO1hYBEHZVMxsbA0z2MMV2Bqnqsm2BcYk
gFDefs0kZM2k3Im2pOtZ
=sKXC
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
