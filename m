Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2JRKju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:39:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53378 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2JRKjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:39:48 -0400
Date: Thu, 18 Oct 2012 13:34:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <balbi@ti.com>, Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCHv2 3/4] dw_dmac: change {dev_}printk() to corresponding
 macros
Message-ID: <20121018103413.GB1449@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <20121017130918.GD11394@arwen.pp.htv.fi>
 <1350481018.3568.3.camel@smile>
 <20121017135306.GG11394@arwen.pp.htv.fi>
 <1350548131.3568.6.camel@smile>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <1350548131.3568.6.camel@smile>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 18, 2012 at 11:15:31AM +0300, Andy Shevchenko wrote:
> On Wed, 2012-10-17 at 16:53 +0300, Felipe Balbi wrote:=20
> > On Wed, Oct 17, 2012 at 04:36:58PM +0300, Andy Shevchenko wrote:
> > > On Wed, 2012-10-17 at 16:09 +0300, Felipe Balbi wrote:=20
> > > > Hi,
> > > >=20
> > > > > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>=20
> > > > > @@ -492,10 +491,8 @@ static void dwc_handle_error(struct dw_dma *=
dw, struct dw_dma_chan *dwc)
> > > > >  	 * controller flagged an error instead of scribbling over
> > > > >  	 * random memory locations.
> > > > >  	 */
> > > > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > > > -			"Bad descriptor submitted for DMA!\n");
> > > > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > > > -			"  cookie: %d\n", bad_desc->txd.cookie);
> > > > > +	dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted for DM=
A!\n");
> > > > > +	dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->txd.=
cookie);
> > > >=20
> > > > now this is critical, indeed. I would suggest using dev_WARN_ONCE()=
 so
> > > > that it's noisy enough to catch the failing user.
> > > To this and upper comment, there is an explanation why it's critical.=
 I
> > > guess the WARN_ONCE is not good enough, for example if we have more t=
han
> > > one user making such noise.
> >=20
> > then use dev_WARN()
> I can't see how dev_WARN could be more useful here than the dev_crit. In
> current message we have channel and cookie to link back to the user.
> What does WARN add meaningful?

a dump_stack()

--=20
balbi

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQf9slAAoJEIaOsuA1yqREcGoQAJM5KdewyfQdjOdUAA/5SVW4
1g2pkif8QIjen2fgy80ETFRuaW4VtCpscaiosa3qaLyg68VkoOmjRnqtBb6KtrJi
obdqmD4pq2eaqrTv7Lm5Z1PndAP/+GbecfMXkSjbcE7FnVM1Oti8CLqiaFfd7O5G
LCtbJcCHwGpgT5Lc9yhOjV/ovS9s/qx98+YinU8FcVYOB24R+X5Pi2KSQ4sqEIas
6WiChBVcZIJjfT0jxUdLGazZXE8XFH8evKlNj7zFF+O9uWko/+30YcwueNSOBp+q
Y3cuhzMSNcNhY+ZpOowKyASGjHFlF5+tdjqo8XL0QYUnPNnQLVDdiPbznEzN1eMU
1g3AA6PnQbyB3J9O8CioOZAtqSMhn0D2vqCqccXF+TaG1mfu7qVXkr4swpXElX7v
139uKMRjTprwJfjJNT2TBIGi8G3PS0oMfVdUeiYhBZQGExi5OPXAf3fc+UJ5RGQc
B/mJMDS2HyvVHZbBYKhVrOxd2za4P8XJYK3obzwXXiMNwxq8ZW/aQ2izL/RC60us
XojdBUwzPV/vUwHzzXAvnQatUN8dHsD4G4vGGxw+3dEPmX5FcXu5rcNnCK35+iuq
bwKVQlXqUggEyD/ABYslIn8bHVpp8yoms+TmNlvWr62J5kCCaAw9CuJHchijENPu
sCS2oOVMGgh0jKrFz6lI
=zrvx
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
