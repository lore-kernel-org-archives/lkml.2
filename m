Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2GWP1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:27:20 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:47846 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab2GWP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:27:19 -0400
Date: Mon, 23 Jul 2012 18:24:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: balbi@ti.com, Vivek Gautam <gautam.vivek@samsung.com>,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        av.tikhomirov@samsung.com
Subject: Re: [PATCH 2/2 v3] USB: dwc3-exynos: Add vbus setup function to the
 exynos dwc3 glue layer
Message-ID: <20120723152407.GC9020@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1342418259-23802-1-git-send-email-gautam.vivek@samsung.com>
 <1342418259-23802-3-git-send-email-gautam.vivek@samsung.com>
 <20120720095134.GG24414@arwen.pp.htv.fi>
 <CAFp+6iENsdZW0tLRA-9QRPh4AvtyLq-Ebpty9zE+bd=hv3dKog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
In-Reply-To: <CAFp+6iENsdZW0tLRA-9QRPh4AvtyLq-Ebpty9zE+bd=hv3dKog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 24, 2012 at 12:09:47AM +0900, Vivek Gautam wrote:
<snip>
> > > @@ -58,6 +81,8 @@ static int __devinit dwc3_exynos_probe(struct
> > platform_device *pdev)
> > >       if (!pdev->dev.coherent_dma_mask)
> > >               pdev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32);
> > >
> > > +     dwc3_setup_vbus_gpio(pdev);
> >
> > I think this should be handled by the gpio-vbus transceiver. No ?
> >
> > I can understand that we can use gpio-vbus transceiver. But i have one
> confusion here.
> We have ehci as well as this dwc3 which need gpio to be setup to
> control vbus. So do we have two instances of this gpio-vbus driver to
> facilitate both ehci and dwc3, because both may be on different gpio
> lines.

Sure... one for dwc3 and one for ehci.

> Moreover, the gpio line right now is parsed from the DT node of the
> device, so while assigning the 'gpio_vbus' field in
> 'gpio_vbus_mach_info', how do we provide that. Please suggest.

gpio-vbus doesn't have support for DT today, just add it ;-)

> One more suggestion please. Now that we are moving to DT we should be
> making changes for gpio-vbus transceiver also for device tree support.

yes, it needs support for DT before you can use it then.

cheers

--=20
balbi

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQDWyWAAoJEIaOsuA1yqREL3YQAJs77TTPGZpsuNfbh3peg8W3
duLz0bNUy6WiyPc06Ad0M1KwLTt+NasTmgmyaroDjqNfnsgulQx2vvSgcsrGXRvO
WHBzwdSGRpRhoSC3tzY9kAd9eLKyDkh2QET8odWZAjCcg/plveMOausf4sCl5et/
zJ4A9TbNSTTMbGwVbLRXOGZAI5/V3zFr8SLALAQBgeMYigBavfAYJnbObqQyYMF3
LDpQBsPPdmsaq3UTGNfmPmR14Gvsh7DXQz6pynOvubV/JngTKIWvEY5+rRSQv6V2
tE50aydArGyJDYKuKJGGdGrPewJB5cpsJkPK1/p2YOrGas7N/mp2g6JWlLgQCp6s
3xduYajVUmSNzLF+InkQxwfsXtgcN/5bpRXWXqf4QMB+4JssbLwWXibQq+pmPLLn
NX0jc8QxLoU4Tcw/4aY+aFKNzn2gPAKKoA2QDKPcnkN73DffH9mxVlwg+Rd3EL1b
xSppEp/gOh9yX3Pq29Afhk1xKt/GoC47dV+gPynWGAbwbvpQBd4QSY43jsEVm+eq
TJWMaPfAdkbM8yirfjd3KRzSJhkVCysSPFKCFmqY50//mW6on6Bp97Y+FW+hLxbO
/fJaHDEnMEkds7yAfa75Jj7axnOwZ3kzq7oh03zKGdGyE8CsAL8dXz+IspFgZgqi
93lziv74N4vxJznwgblV
=KEaZ
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
