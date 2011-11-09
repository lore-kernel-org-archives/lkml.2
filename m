Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1KIKoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:44:07 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33074 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab1KIKoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:44:05 -0500
Date: Wed, 9 Nov 2011 12:44:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
Message-ID: <20111109104359.GB16165@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
 <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
 <20111108120635.GA2531@xps8300>
 <CAAe_U6KVvpJBe2nHzpyMN7iT6Q+1JJd5zfGUu99hq=agEjz1jQ@mail.gmail.com>
 <20111108150441.GI20728@legolas.emea.dhcp.ti.com>
 <20111109085234.GC2531@xps8300>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <20111109085234.GC2531@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 09, 2011 at 10:52:34AM +0200, Heikki Krogerus wrote:
> Hi,
>=20
> On Tue, Nov 08, 2011 at 05:04:43PM +0200, Felipe Balbi wrote:
> > On Tue, Nov 08, 2011 at 08:28:15PM +0530, ABRAHAM, KISHON VIJAY wrote:
> > > > Maybe I'm misunderstanding you, but sounds like you are still marry=
ing
> > > > OTG with transceivers.
> > > I'm against the idea of usb_phy married with the transceiver (i.e
> > > transceiver =3D twl6030 for instance)
> >=20
> > I think the source of confusion is the split phy functionality on OMAPs.
> > twl6030 basically provides VBUS/ID comparators which communicate VBUS/ID
> > levels to internal PHY via a well-defined mailbox. We need a
> > good way to write that down in source code.
>=20
> OK, I think I understand now. So this issue is not in the scope of
> these patches, right?

probably not, still worth keeping it in mind ;-)

--=20
balbi

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOullvAAoJEIaOsuA1yqREjDgP/3++XTv8DsbrYaxHMp7pkDCZ
BRyY//YNkM3XzxyaWIWcj5yPaTRPnCu2NRdAmQqfOE1b0oC1Yof+ATMcUlPVA8kd
HR987rhPvno7dB7ULm26YI28uaAcawL2mJQpXR4PUBpYOnq/cou4p1haTe/FioLC
0GQFA7Suw8UbQAbFIqdjo0FLSgXQE1k2JgHl7TTfSZPe3Ga5+dLE6ONdYMOuBfsF
CYqh5OE9+kD8HQdq0LNAgcDHXB8+mnZvtGWKPz79lp3+rwiXa0nGm0dbgDprA+JY
suTx880+0yXY9n/f0AO9Bsehk9ubeB98sun8Qsqjhlx5F9plA3ZRr/yoUM25UQX5
vYUZp8IdnF2JTnJh0AnHgrh4sC3Dil2rMlggBJIa0bhrDcKWC8R9zHBPLLdS+PnU
qJt9qOfTAJ7jShxJizpzIDPhBjE8+ofs2sZHyktIqpWyYFl2Kv20KHrA0tcoIVYA
BXrhutmXsZMfFBKJjFZoyh8pIR9dWD5ip38Bi295kLZrIFyPa2kp3cHFqykPH0Hv
v5204NrKDQMdmzGOh/2yRN54QtnQ6mUUYijYInUiyjnKab8WYk2IUB1wWTyBIn6o
wQaYe3nxYjNG3xg0yOYRPZ4hrLYTftvWs3ZWiKAcDporcRtuVAXzd7jaMn9aOwnH
nrESG8v99eTnk/5VzcaB
=g5k8
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
