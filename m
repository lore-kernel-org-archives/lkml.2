Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2I0INO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:13:14 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:53422 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755955Ab2I0INL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:13:11 -0400
Date: Thu, 27 Sep 2012 11:02:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: balbi@ti.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 3/7] dmaengine: dw_dmac: remove CLK dependency
Message-ID: <20120927080223.GN12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <20120927074236.GI12592@arwen.pp.htv.fi>
 <CAHp75VcPb2KrxYYv8F27bSszLwHi0BN5VPxmuEXmGtUPziuigQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l3ej7W/Jb2pB3qL2"
Content-Disposition: inline
In-Reply-To: <CAHp75VcPb2KrxYYv8F27bSszLwHi0BN5VPxmuEXmGtUPziuigQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l3ej7W/Jb2pB3qL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 27, 2012 at 11:04:54AM +0300, Andy Shevchenko wrote:
> On Thu, Sep 27, 2012 at 10:42 AM, Felipe Balbi <balbi@ti.com> wrote:
> >> -     depends on HAVE_CLK
> >
> > as is, this will break compilation of any arch which doesn't set
> > HAVE_CLK.
> As Viresh suggested and I checked it's not.
> He wrote nice patch that adds stubs for such case.

Great, that finally reached mainline. I was waiting for that patch for a
long time, actually :-)

thanks for the note

--=20
balbi

--l3ej7W/Jb2pB3qL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAgPAAoJEIaOsuA1yqREubIQAIE+0tcKmDsFnSlSc2mXR59A
gJC6B2kIh/kX5U9ETC3k9R/iGCdr7PFa7rmt3gUkt0UN2hZ/AjA140IkJr7Pj1rP
yJEDPbKra4k9FIFmAO+jU2iuSHMKCz3hurZHPWe7asa64L3MCUSarDEuiWcrFqzH
Ws2Q7oh4XfjYw+txaKSCG+r2cLQDDBZFKLpBNFmqRhhhyoHmJgyvKl7bYacIMnaK
3mUXh1XhPNwcwveyiJOcpCOrRRVYbI5qnaw68je8Z2XFw7sxl8b1TkaCgM9UJi0f
qIRZjs9+t6PaOHokRi09eeLaL6wN4aDEOM3KCgkSXyBMBKOkWT+VlFAuZ5sDJqOC
byanedzG7rPLC2xqCUlGMtdo70Ae7qaEI8mQ/nBmCSADt4njWfVgkbYply7bA9Va
rpi+/LSCUP9+TfPLY6kjlhq5zdtKfk8H5f47bon7/NftA0ESeiCPoHih5cCXhzrY
zs2P840tGUYib+GH01yfbFz0SNR20zLKzUN53+GkLWl9iIiM6avKoJO0Sbvym5xo
gJVldG8j+rPN5BG7FdklJleNugZGJTDAXJ/b6idFnWC5uqQYrixwvof9suMsg5Tm
TNhb86vHAwBHgtPsrLuhu7VdNBsPnLQBr4wYfxiMgQ4nRAS9mAUaEePeSr8MonKA
O0UWyeQklzLt+uydVIgD
=NU1z
-----END PGP SIGNATURE-----

--l3ej7W/Jb2pB3qL2--
