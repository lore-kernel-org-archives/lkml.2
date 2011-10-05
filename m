Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab1JEIwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:52:45 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:53795 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932659Ab1JEIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:52:43 -0400
Date: Wed, 5 Oct 2011 11:52:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the usb tree with the arm-soc tree
Message-ID: <20111005085237.GB24472@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111004165030.ab90295677251fc80bf843a2@canb.auug.org.au>
 <20111004152611.GC29994@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <20111004152611.GC29994@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 04, 2011 at 08:26:11AM -0700, Greg KH wrote:
> On Tue, Oct 04, 2011 at 04:50:30PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> >=20
> > Today's linux-next merge of the usb tree got a conflict in
> > arch/arm/mach-omap2/Makefile between commit f41caddbe73f ("omap2+: Use
> > Kconfig symbol in Makefile instead of obj-y") from the arm-soc tree and
> > commitb 3c3dc22366b ("usb: musb: fix build breakage") from the usb tree.
> >=20
> > I fixed it up (I think, see below) and can carry the fix as necessary.
>=20
> Ick, what a mess.  Tony and Felipe, is what is below correct?

looks ok, but I don't see omap_phy_internal.o being added anywhere.
Maybe this hunk doesn't show...

--=20
balbi

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjBrVAAoJEAv8Txj19kN1NvYH/j+ulDV3Hph1PA8VhY+Kbc/L
dXq5VwGWWr5FBuo7P1FbkfIf+YdbsSilLBzMpTWDWgHYn/tUZKVU8hIDIFrGUDy3
yHhBeGVXf7Zl9QwbpKlkXXBgYG4FBky7Op0UCRxnbw737v/6Dm2gwCQp2ysMBWEv
W+ERS0O8DykoDBdvss7FLM1J0j/jc2sOGN0qzmG7jkdag9JMVeEkQf9Oldd7EI6r
d0o8iSbRsNn9ZPyH04G9Q5zUGdGL5KsNTItKKGeqVngQ/4tJZ/m6tzH8IHNazVDA
iRkUUsVGBMIIWJlCzqzUPFZHPNNQN/rbo/lEH5FouQTqn5kYdY5pgy2ez6qWhic=
=JPIe
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
