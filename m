Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab1KHPEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:04:53 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:58173 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab1KHPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:04:48 -0500
Date: Tue, 8 Nov 2011 17:04:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
Message-ID: <20111108150441.GI20728@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
 <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
 <20111108120635.GA2531@xps8300>
 <CAAe_U6KVvpJBe2nHzpyMN7iT6Q+1JJd5zfGUu99hq=agEjz1jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SdaPbLtAangIkrMZ"
Content-Disposition: inline
In-Reply-To: <CAAe_U6KVvpJBe2nHzpyMN7iT6Q+1JJd5zfGUu99hq=agEjz1jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SdaPbLtAangIkrMZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2011 at 08:28:15PM +0530, ABRAHAM, KISHON VIJAY wrote:
> On Tue, Nov 8, 2011 at 5:36 PM, Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
> > Hi,
> >
> > On Tue, Nov 08, 2011 at 11:27:12AM +0530, ABRAHAM, KISHON VIJAY wrote:
> >> Hi Heikki,
> >>
> >> I tend to defer with your opinion of renaming otg_transceiver to
> >> usb_phy. According to me otg_transceiver should program hardware
> >> mechanisms associated to VBUS, ID lines, etc.. and phy is responsible
> >> for transmitting data over differential data lines (with its own
> >> programming of phy_init, phy_shutdown, setting phy clocks etc..). So
> >> in my opinion otg_transceiver and usb_phy should be two different and
> >> separate entities.
> >
> > Maybe I'm misunderstanding you, but sounds like you are still marrying
> > OTG with transceivers.
> I'm against the idea of usb_phy married with the transceiver (i.e
> transceiver =3D twl6030 for instance)

I think the source of confusion is the split phy functionality on OMAPs.
twl6030 basically provides VBUS/ID comparators which communicate VBUS/ID
levels to internal PHY via a well-defined mailbox. We need a
good way to write that down in source code.

--=20
balbi

--SdaPbLtAangIkrMZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuUUJAAoJEIaOsuA1yqREljwQAIayeWi4Ofwzy4QBSzY9Jx2X
lbiLESgC69fnESghlCPWPSAP700YcXPxGq0dnXjQ6SKHTBc0qajDtii7crxWmqwr
HAT6CG6Pa8g+jP9ttpmr60FrI8VlKlsngZzRPl06yzjK7TZSUP7cQ5KXoWQ7U/VY
UMOYg+ccYaB6RQM7aTMeyhWPkzrlMjntGeRURpEM2w3rVEMY1R9NvuWz2CwPtc+m
TWbbfwm0wVktxFLv0hc3KKf0wEVE3htmjtszgZ8WW0A/OPSsW3U0tSTWdB0w/GN3
VFD+sDBhKCsyvH8PETYyzVUGlPst22xW48sdfKqrnGG0xEZ9z16A8bXPSfvScNFr
X1pe9+MQFSbO+5HxE0j0z+z07cpFFrIldwtvstOOlpWgOF7Y2IteHHj+xYjHYd+9
G2JNdeSbzcbQyeOsEii71m8uBRx+i8O/D8V4bXYLOW0q08w/cOCChdftgKpWNiNG
Hv17JhSMcqAd8HW3vj90yJzfEhctcz+1wGKHInCnM5jV/MWfTGSZZOfCfk2vQe8L
jBoCsh/cUdh03lcjJVq1xrIj2vhShUibOE3h6bhVKrfMEPgt3lQjKFxJZoevowts
1sPskD0syeuHhW5d+lroNEPx0fsSIbDr77SuJocq+/fO1RHLFjuDx3Xj0EWVr9WS
3FsAOc6S8GUOdLP81vTv
=ovID
-----END PGP SIGNATURE-----

--SdaPbLtAangIkrMZ--
