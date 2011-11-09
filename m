Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1KIGgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:36:47 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:38447 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab1KIGgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:36:46 -0500
Date: Wed, 9 Nov 2011 08:36:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <hzpeterchen@gmail.com>
Cc: balbi@ti.com, Peter Chen <peter.chen@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
Message-ID: <20111109063638.GF23337@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
 <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
 <20111109012237.GA2231@nchen-desktop>
 <20111109060649.GC23337@legolas.emea.dhcp.ti.com>
 <CAL411-qpW4dNUMTwh4gP_M+i_UOzc7q84gH+qJWeAYaSCgBCJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oFbHfjnMgUMsrGjO"
Content-Disposition: inline
In-Reply-To: <CAL411-qpW4dNUMTwh4gP_M+i_UOzc7q84gH+qJWeAYaSCgBCJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oFbHfjnMgUMsrGjO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 09, 2011 at 02:15:43PM +0800, Peter Chen wrote:
> > > > > Includes fixes to IMX code from Sascha Hauer.
> > > >
> > > > I tend to defer with your opinion of renaming otg_transceiver to
> > > > usb_phy. According to me otg_transceiver should program hardware
> > > > mechanisms associated to VBUS, ID lines, etc.. and phy is responsib=
le
> > > > for transmitting data over differential data lines (with its own
> > > > programming of phy_init, phy_shutdown, setting phy clocks etc..). So
> > > > in my opinion otg_transceiver and usb_phy should be two different a=
nd
> > > > separate entities.
> > > >
> > > I am a little puzzled, are there two separate analog usb parts at OMap
> > > 's usb part? What the transceiver do? And what the phy do?
> >
> > Kinda... there's one which is mostly digital inside the SoC handling
> > data lines and also comunicating VBUS/ID levels to the link but the
> > actual VBUS/ID comparators are outside of the SoC, inside the PMIC.
> >
> > It's a bit of a pain, but I understand why they did it that way. It's
> > mostly for power management, although the same is likely to be
> > achievable by keeping everything in the PMIC.
> >
> So, in that way, the users must choose specific PMICs which have USB
> interface if
> they want to use OMAP

OMAP only works with its own matching PMIC. It's not like you can go to
a shelf an buy a PMIC for OMAP. OMAP's too complex for that. That's why
TI also provides the PMIC for every OMAP Silicon.

What can be done, though, and has happened before, is that some
companies will completely ditch the internal transceiver and the pieces
inside the PMIC and use another ULPI-based transceiver.

--=20
balbi

--oFbHfjnMgUMsrGjO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuh92AAoJEIaOsuA1yqREfRQQAKS2Mhi91/YIsLTDapMrij4c
jedf5k9kA6DWOS972T2bNU4alOmyAfjk4I2p3d0G++xaPyHLUictvB72YFuX0S61
Yq9XlEIgoT5HCPTmXs6nrsMXVItIjZN4pi5lnkcmZ8pPYnihlQuZsPyaItx2/C86
lTD98rtUzdQaLCmp8a5Dh5KjJ1nFv38ueUR/BGADAYkYoe2mjXmo5D6KcMJHYPdA
IwFxqjg8B8V3/kNG9F+DlrKWQHVvSj86DNb5jVeYSXv55901b99SnLJOKPmGYrh3
GrMu341TAHHaO8B53hYJFvqBm5G/DYue23uQImY1rvYtH288wW8N36XhWplCiiBj
EUimSMbwCzBahl233EHstTlV1f8cJ8KRvIM9tVVst5TGLoVXWkY9cA5jqI3fmHNs
ooAK1h0A9E6khwrQuwSAIK/WvDjnnh7ufFV0QseFw9hXg+sN2JCxDi+pVoDcp+uq
PZJmZR8XRNaDZUf/cRkzNJB4I/zYh8QUfB9B9wPgHti+LlnlxIiWjZaUNaP7q0W6
djiIjBNyBxoDLkhGFknMY7/aXN1JWRz0McIXQmxY2uHwvJSfa9Am2az3MRI2bWzi
bMFeoMYVtvyKppfPFvkyqvuMDd00tO/BwUGvF7vqf7CBZMxwIml4gpVwRL1+ZcDt
cgWPM+a+GVcxCgufifJb
=OJDW
-----END PGP SIGNATURE-----

--oFbHfjnMgUMsrGjO--
