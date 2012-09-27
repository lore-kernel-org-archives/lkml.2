Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2I0IVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:21:48 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:48837 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab2I0IVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:21:45 -0400
Date: Thu, 27 Sep 2012 11:16:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 2/7] dmaengine: dw_dmac: add module alias
Message-ID: <20120927081646.GQ12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-3-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x==fDa9BFYHUqRW4T5nxr_O_=W4k2ghYXQ4CYhvsYuDBzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HAv5+T9jbwMPl6Kw"
Content-Disposition: inline
In-Reply-To: <CAOh2x==fDa9BFYHUqRW4T5nxr_O_=W4k2ghYXQ4CYhvsYuDBzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HAv5+T9jbwMPl6Kw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 01:46:57PM +0530, viresh kumar wrote:
> On Thu, Sep 27, 2012 at 1:01 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >
> > It's good to have a quasistatic name for the platform driver.
> >
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index 0b88ced..bbb2a82 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -1712,6 +1712,7 @@ static struct platform_driver dw_driver =3D {
> >
> >  module_platform_driver(dw_driver);
> >
> > +MODULE_ALIAS("platform:dw_dmac");
>=20
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--HAv5+T9jbwMPl6Kw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAtuAAoJEIaOsuA1yqRETUUP/jJlu2nZ9eJtAXrEahSetqt9
Wwk61qGzY0l824FKdWOUWyjP+N6OeYkJ1ISO8fAsYj0kHrffhp2n1lqff5MaFqqX
rixa/rGNPogoR42Lm1FjbzQPMvoppokksWwof6d1mF0HBG6H0CmKWSdomK6t9eL2
+4LuAiqrOKkepDpsrdZy5pITqGPrL7kET0MuT2rdF9bMjceAlGhiBD++Xrh/e7f2
Lg2kxL3UzwvFHoAvnte61aHe+hgQ9Q9DpXa1Rv8550ocJgomkVUrb+CvVmAL8qU1
9hCbucw0Bcj6jWRvNtjVM2/bJy5ZddWveNncWxLxjA/OGRrxVWEB3nfQGIxNdVmB
XmrU8P8tnzD+V+d+WHuDaDM20etuDh9YZjsDqJpsHAW8xRZXA1XXWvH4X87NZFm8
xrdn6BIwwBEUkBmwyrqvOm3+Wf5Tvw21wejrciR3AtJl661hg2HMDZyE58aZ+rM3
cyYQUDtt4t/oLj3fxVb1jo4FKOvPJVkWZwGDTZlSn4mT/FtqPeVxkLrDTUBSsvrA
oAH9wySSqB41q4pmZnVhBOKGKNrJynyV0A1jHRVREj/lomrldoM53+U1IBYODufU
hjVr2jS9ak5ov0ms+tC0l9gXRxBDjxylDg0CMLSuxB2q8X9OkC76kh7JCLAGd2JE
mIK05zJUBK8XL4xAkD8o
=LcBL
-----END PGP SIGNATURE-----

--HAv5+T9jbwMPl6Kw--
