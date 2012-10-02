Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2JBNtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:49:13 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:54833 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753925Ab2JBNtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:49:10 -0400
Date: Tue, 2 Oct 2012 16:44:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>, "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        b-cousson@ti.com, santosh.shilimkar@ti.com, sameo@linux.intel.com
Subject: Re: [PATCHv3 1/4] mfd: smsc: Add support for smsc gpio io/keypad
 driver
Message-ID: <20121002134400.GA12125@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1349089282-22105-1-git-send-email-sourav.poddar@ti.com>
 <CAAe_U6+zEGuwMC1yn7O=LXE6PhPvPc2i7DCF0EAprkE8s+-iEw@mail.gmail.com>
 <20121001114454.GA9170@sirena.org.uk>
 <CAAe_U6JX9QDWvWA3KH7E9sOv0EHGkozVONuXDgn+a2MZ4GTE7Q@mail.gmail.com>
 <20121001120907.GK4360@opensource.wolfsonmicro.com>
 <CAAe_U6K6nAjsZUOk2rBFweWHtJmcLF7EJDpu9O6FXrq3tzv3yg@mail.gmail.com>
 <20121002123856.GX4360@opensource.wolfsonmicro.com>
 <20121002124321.GD30762@arwen.pp.htv.fi>
 <20121002125819.GY4360@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20121002125819.GY4360@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 02, 2012 at 01:58:20PM +0100, Mark Brown wrote:
> On Tue, Oct 02, 2012 at 03:43:22PM +0300, Felipe Balbi wrote:
>=20
> > BTW, OTOH writing all children into the DT actually describes the HW,
> > no ? And depending on the device I feel it'd be better to write that
>=20
> Well, it depends on the hardware.  Some hardware has a bunch of nice,
> neat IPs which can usefully be reproduced and which map sensibly onto OS
> abstractions but a lot of it doesn't and frequently the abstractions
> which Linux wants to use don't bear a huge resemblance to the hardware
> (and Linux's ideas can change over time, as with the clock API being
> factored out for example).
>=20
> > data to DT. Think of twlxxxx (TI's PMICs), we might have completely
> > unrelated drivers using one of TWL's GPIO lines as an interrupt source.
>=20
> > If that particular children isn't listed in DT, it can't be used as an
> > interrupt-parent, right ?
>=20
> You can have the interrupt controller there without having to list every
> IP in the device, just make the parent device the interrupt controller
> to DT.

fair enough, thanks ;-)

--=20
balbi

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQau+gAAoJEIaOsuA1yqREuZ0QAIoB5fehsY09bdFte9fouqQs
TVFxWhnzgNcpzswXn/HiwbuM2NuqMZcLOfbOeyXtHz80+xDwvzxWeijMrSJcPWE2
IxwbrfuEjpdtKpBjpAQ+Sg5l1f4sT4FKTOTkoEqiO18Et6Bd8kiG00UGEk0YXNlx
WJqbFCCTOIvKEmWUp4iqOMLgcEJxYsezXa0wj+dRqu4uwRtXiqRcHFVRPWFU1bBg
edEPd1OouLB6eB4NyYLjrNmsMz1pJ9xwSClviRSB142xip5+pzmguCinDEJ6U224
4xpZLO3iUmFyFwVt1JVIpeu5+GFIxQzvGXmAScIldLLv5PehkimZtIzHlehsaEV9
wZXjOp6KC7nD8fx7toOT9Uk18vkPfvvVvEhR4Z8a6wLM493/SUvKV1UliawsbG19
wMFr0WHcZlTkPD5Hir98f47iflhS2/Z55QZWEcquVv8ZEK6xMp/GOYsdboqJDmcM
2X3gzoLfDm5/JOhtfMGG7nfLNqX+LJvHnqpdot3+xvvdYYrrvyFz5/gH/hswtFZz
1+bgOWmD+3y0dtTRv/bJEGsO9kUqcerircfjtyryF4EoDyrcK+vuuiZ57DR6eb0+
FMFVUvToQFDXCCYXiSG31XJB8r/vO6gVk/vseDqO+pfcHCfd0AjNbJadP/BKI+xl
srqApwYFsjn70Go+AhkS
=u8pA
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
