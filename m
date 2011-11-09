Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1KIGG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:06:58 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:59547 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab1KIGG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:06:56 -0500
Date: Wed, 9 Nov 2011 08:06:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
Message-ID: <20111109060649.GC23337@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
 <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
 <20111109012237.GA2231@nchen-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <20111109012237.GA2231@nchen-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 09, 2011 at 09:22:38AM +0800, Peter Chen wrote:
> On Tue, Nov 08, 2011 at 11:27:12AM +0530, ABRAHAM, KISHON VIJAY wrote:
> > Hi Heikki,
> >=20
> > On Fri, Oct 28, 2011 at 6:05 PM, Heikki Krogerus
> > <heikki.krogerus@linux.intel.com> wrote:
> > > This is the first step in separating USB transceivers from
> > > USB OTG utilities.
> > >
> > > Includes fixes to IMX code from Sascha Hauer.
> >=20
> > I tend to defer with your opinion of renaming otg_transceiver to
> > usb_phy. According to me otg_transceiver should program hardware
> > mechanisms associated to VBUS, ID lines, etc.. and phy is responsible
> > for transmitting data over differential data lines (with its own
> > programming of phy_init, phy_shutdown, setting phy clocks etc..). So
> > in my opinion otg_transceiver and usb_phy should be two different and
> > separate entities.
> >=20
> I am a little puzzled, are there two separate analog usb parts at OMap
> 's usb part? What the transceiver do? And what the phy do?

Kinda... there's one which is mostly digital inside the SoC handling
data lines and also comunicating VBUS/ID levels to the link but the
actual VBUS/ID comparators are outside of the SoC, inside the PMIC.

It's a bit of a pain, but I understand why they did it that way. It's
mostly for power management, although the same is likely to be
achievable by keeping everything in the PMIC.

--=20
balbi

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuhh5AAoJEIaOsuA1yqREr6AP/RF3A12Xm+QO4wT9sGLrTOn/
+DELsqsMYFygqqS8sBWNF0YDlQ78SPyG8boO81RtmZjoPmuzbwllek+udyrolqyW
QUwEQKFEYE8hWfhzpuK2wL5AhMGgi09KKIMiYnJgUP1kzu8fH7okM0Q2PM+T5LKI
lShYMMUz/9aP85JndTVKTedCf5v30f6aN3+nQN60ZuWAgyRqCGHW2xEDVIo+fngX
m0NsBdbbFL3y3bUmoAx+n/8R4pKmCfyHBeHtRlW81EbO9WChrI91R1jWCJxho892
LjiJ6kxvpOKaqqE3FvS9+1TwmQ+e1QQgrcrs3WesLA20DXgeuM+H0jdR1K2/BSmF
6W66Wmrw8S/q4x08vbRvafNkXP+KCM42d3LEM76/kb0ZpiqBiIcRm0duPkxAlcte
gWjIdXW6g3HD5BPtFbtzbS/oopjo8sxwSQTVGG1xNl55zK8EfcePcHd3Bj3/d2J3
DfxR83GaGC/MkmAm3MGTRPU4wXJKmJV6+kGJIyEShWh2Q52VjjGmVlF42JToQ94P
51TSXdtyUfHdxO1WPUM705q0TMt+ATdQho9ElWpookYjeih0/qn2bELqzcBCkOki
vdOS5IHPGWbwtYcs6k7D0V/lujl90fUGmQQzGz/KbD4iNOUSWAPRpPRMfoL47mG1
zIlcEDXKmrcL3UGVsljs
=yOGP
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
