Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab2I0IWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:22:04 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:45469 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627Ab2I0IV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:21:59 -0400
Date: Thu, 27 Sep 2012 11:17:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: balbi@ti.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 3/7] dmaengine: dw_dmac: remove CLK dependency
Message-ID: <20120927081700.GR12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <20120927074236.GI12592@arwen.pp.htv.fi>
 <CAOh2x=nBZs-pPrFQ-bsaCsH7gB2y-Y-4RoCnmSCmCtn9JQy8sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FNX2SHge3qdlDajY"
Content-Disposition: inline
In-Reply-To: <CAOh2x=nBZs-pPrFQ-bsaCsH7gB2y-Y-4RoCnmSCmCtn9JQy8sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FNX2SHge3qdlDajY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 01:47:58PM +0530, viresh kumar wrote:
> On Thu, Sep 27, 2012 at 1:12 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Thu, Sep 27, 2012 at 10:31:57AM +0300, Andy Shevchenko wrote:
> >> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >>
> >> This driver could be used on different platforms. Thus, the HAVE_CLK d=
ependency
> >> is dropped away.
> >>
> >> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >> ---
> >>  drivers/dma/Kconfig |    1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> >> index 677cd6e..df32537 100644
> >> --- a/drivers/dma/Kconfig
> >> +++ b/drivers/dma/Kconfig
> >> @@ -83,7 +83,6 @@ config INTEL_IOP_ADMA
> >>
> >>  config DW_DMAC
> >>       tristate "Synopsys DesignWare AHB DMA support"
> >> -     depends on HAVE_CLK
> >
> > as is, this will break compilation of any arch which doesn't set
> > HAVE_CLK.
>=20
> No, it will not due to following commit id:
>=20
> commit 93abe8e4b13ae9a0428ce940a8a03ac72a7626f1
> Author: Viresh Kumar <viresh.kumar@st.com>
> Date:   Mon Jul 30 14:39:27 2012 -0700
>=20
>     clk: add non CONFIG_HAVE_CLK routines
>=20
>=20
> @Andy:
>=20
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--FNX2SHge3qdlDajY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAt8AAoJEIaOsuA1yqREz1cP/06k5tYO7AUZyxEVqBNvhMHk
vZ3c5T0KLs+61mrgF3qeU8kaFnGjlwdVCeijZL/VS0eh84FVZGv6lnCOdMpYfGJ0
N4dRc6jv2SaccGq0WG/QlYYkY99QHLKsuxVnq/XKFchKNO/85c3s9vRk8CG5S4MN
3jdK/0i/5TNbpZlpeRnKyc1aCrNvVvQXH/CYGc5Q8CP1w7MiIFynPBr2NHAT33Kc
rO+N/N6FoiGpme9xCCkdTKrEL1obhnk6nKttMQsK169BsvnK7GZ7DuiGO0vqXK+0
NzjLhS1W4MKQ1kYx8vZV4iQ7bCQeFsklRZsNpGjiIGWYf+xzj9StUPrfrVhyoF5r
XIvfp2kOX0O0z4+HyODmD4YtXZ4LCcmkPWBZGootEMGn9iJfdorJuhutLJdfOyid
bnNdO7SmubECNUf4EFuopokzmXJoZlH+asbxNh1ZOc7SfnqVGRGLhriLYVIM5GD8
74OL+L4UQvEA7iarUwGf5gNbeV4fMwIWHd9dCIDMxsLi4kpMzlUdCCmBoagtJpvc
DL+f2XDlIdat3Q23sxUiEivZIylupwFb8uQYj0gx2JM414qcw9fnLHvMd7KmHy36
3f2nbcyn3Jqzp7xkhq6BA5SIt2td6WMipRM3PId68ldGRc7VVtooUWztNQUEr2Z4
pEE91+rz6MQV2gE0Lnhz
=fQIL
-----END PGP SIGNATURE-----

--FNX2SHge3qdlDajY--
