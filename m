Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab2HFJrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:47:39 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48954 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249Ab2HFJrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:47:36 -0400
Date: Mon, 6 Aug 2012 12:44:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: balbi@ti.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        b-cousson@ti.com, rnayak@ti.com, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
Message-ID: <20120806094401.GI17551@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-2-git-send-email-kishon@ti.com>
 <20120803132708.GC8269@arwen.pp.htv.fi>
 <CAAe_U6K15Nm5aNs2Vn71G7ELZWka1zB2E3VGZWTc0VjyViJ6Yw@mail.gmail.com>
 <20120806084928.GD17551@arwen.pp.htv.fi>
 <CAAe_U6LhfrRk7PP-Td7BTXPngo7+chvTp4LwwKR_GbsjE4jNJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UthUFkbMtH2ceUK2"
Content-Disposition: inline
In-Reply-To: <CAAe_U6LhfrRk7PP-Td7BTXPngo7+chvTp4LwwKR_GbsjE4jNJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UthUFkbMtH2ceUK2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 06, 2012 at 03:14:42PM +0530, ABRAHAM, KISHON VIJAY wrote:
> >> >> +static int omap_usb2_runtime_resume(struct device *dev)
> >> >> +{
> >> >> +     u32 ret =3D 0;
> >> >> +     struct platform_device  *pdev =3D to_platform_device(dev);
> >> >> +     struct omap_usb *phy =3D platform_get_drvdata(pdev);
> >> >> +
> >> >> +     ret =3D clk_enable(phy->wkupclk);
> >> >> +     if (ret < 0)
> >> >> +             dev_err(phy->dev, "Failed to enable wkupclk %d\n", re=
t);
> >> >> +
> >> >> +     return ret;
> >> >> +}
> >> >> +
> >> >> +static const struct dev_pm_ops omap_usb2_pm_ops =3D {
> >> >> +     SET_RUNTIME_PM_OPS(omap_usb2_runtime_suspend, omap_usb2_runti=
me_resume,
> >> >> +             NULL)
> >> >
> >> > only runtime ? What about static suspend ? We need this to work also
> >> > after a traditional echo mem > /sys/power/state ;-)
> >>
> >> The static suspend case is handled by users of this phy using
> >> set_suspend hooks.
> >
> > I'm not sure if that's too wise, what if your user enabled USB, but
> > for whatever reason loaded only the phy driver and not musb or dwc3. It
> > will fail, right ?
>=20
> The enabling and disabling of phy is solely governed by usb controller
> driver (musb/dwc3). So if you dont have musb/dwc3 loaded, the phy will
> be for sure disabled.

fair enough... that's ok then ;-)

--=20
balbi

--UthUFkbMtH2ceUK2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQH5HhAAoJEIaOsuA1yqREFAYP/0Tg9jYi+w6+3EISdUAnuQXj
g8RJET/C2H72vx/2MS7PbqLhNb22pAw1+NrEB1hq3z450DTln+yRg0xVsYL7/OkQ
qLrW4ARCG7CUd54n1gDPuIlOkH1qpcNxenpJfxxOuTbs+vejXWBulBzoRfbFZySy
uh8GA3mFOvrBqmkeWhNlPQ2qoWhETEXgxqkmylX0FSW67arB/qWvkwVuPuGv/O70
y1MnXvUPeoYUVRm30m8TKzFMWrX58A5YqfPuwEmuOhziJpHT0lUKxL3xJhDD//qZ
zD9P4D5KXKnx23ruFlfRCdfFMs8SNPRTgQvdTr9gQnM+U0eaHUQFSRFiVYZHHdB0
EQZPqWp0qUhAGAJendrDXhfPjaUo8cyvVFdWx4uOAkObn5AutP2s+FOZIF6HmGg8
ewAmRcB4uKgeG9DNiVyfhCh3s3C7nLMgAn9/adQFmfXRK3Z+bos4Hr1BJ9+RXAL1
2o0imPpz2x7fucPoXoQBYoKJME+29d5slCfpK42ypHo9CS8Q/yUaxmSS1DUhpTmM
Y5T0pGNmHHXnZAHT2vdR31OaUnMpMFgGA1jk/76grdnA62eAEgtEXp4A7TqAzL14
6HQahuxXnPZuoDH/WZJtvVOpEDdFI/MuCJVw0t8dM2U7bgjQD0ep7U94TNFSVm6N
kiZ5+IO93rKVrF0oxTCv
=nEBC
-----END PGP SIGNATURE-----

--UthUFkbMtH2ceUK2--
