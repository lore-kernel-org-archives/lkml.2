Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2GLEbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:31:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35410 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab2GLEbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:31:04 -0400
Message-ID: <1342067445.25597.353.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
From: Ben Hutchings <ben@decadent.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@linuxfoundation.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Date: Thu, 12 Jul 2012 05:30:45 +0100
In-Reply-To: <201207112104.49173.rjw@sisk.pl>
References: <201204292244.16467.rjw@sisk.pl>
	 <201207111107.56500.rjw@sisk.pl> <20120711135333.GA19410@kroah.com>
	 <201207112104.49173.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aAqBNxXpbUMQCzstgQQq"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aAqBNxXpbUMQCzstgQQq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-11 at 21:04 +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 11, 2012, Greg KH wrote:
> > On Wed, Jul 11, 2012 at 11:07:56AM +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, July 11, 2012, Greg KH wrote:
> > > > On Sun, Apr 29, 2012 at 10:44:16PM +0200, Rafael J. Wysocki wrote:
> > > > > From: Oleksij Rempel <bug-track@fisher-privat.net>
> > > > >=20
> > > > > This patch makes _SxD/_SxW check follow the ACPI 4.0a specificati=
on
> > > > > more closely and fixes suspend bug found on ASUS Zenbook UX31E.
> > > > >=20
> > > > > Some OEM use _SxD fileds do blacklist brocken Dx states.
> > > > > If _SxD/_SxW return values are check before suspend as appropriat=
e,
> > > > > some nasty suspend/resume issues may be avoided.
> > > > >=20
> > > > > References: https://bugzilla.kernel.org/show_bug.cgi?id=3D42728
> > > > > Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
> > > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > ---
> > > > >=20
> > > > > Bjorn, Len,
> > > > >=20
> > > > > This is -stable material and therefore v3.4 as well, IMO.  Please=
 let me
> > > > > know if one of you can take it or whether you want me to handle i=
t all the
> > > > > way to Linus.
> > > >=20
> > > > What ever hapened to this patch?
> > >=20
> > > It was split and partially merged.  As far as the other part is conce=
rned,
> > > the jury is still out.
> >=20
> > Ok, I'll wait for someone to ask for it to be added to the stable tree
> > before I do anything.
>=20
> In fact, it should have been marked as -stable material, so please add:
>=20
> commit dbe9a2edd17d843d80faf2b99f20a691c1853418
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Tue May 29 21:21:07 2012 +0200
>=20
>     ACPI / PM: Make acpi_pm_device_sleep_state() follow the specification

Queued up for 3.2.y.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-aAqBNxXpbUMQCzstgQQq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/5S9ee/yOyVhhEJAQpZgg//WQ25sCA13c/wGirL+KJmK9IoUjmwwOkp
TWLvFkqbt+sLGvDwc1MAki6mrzv5VTiDE+ETbNmwvQ8FLN6naSSeHkbJFZvorQ4j
bGSBig+gglfWeaOGkW1UdE5METuEYCrjB7ImwIGS2r2VDB2dzCR4+3fqy4u0jYZd
nxodr4fGco3Q5Du8lsCZ2zg9AeehXG+f2bjdkBvxDDpHMKBEC6CHQtuLsUKgQV18
wiovxVVT45DLv0qEeY7UTN1vJAkxce21EqEI1NXBP4pVTXg3gAIz/vye8e6EAu0x
MRrHJ25/w0vgB8lDby9MiUX4eJlpNhtBTSQE+NhZv0OKCJjbmj68OKqHQt8UtvnH
+8QB4+R52nBGTrcEBTHqA6lU1x9B4rmlkCJdJMN/Ws1/GfBPmqrKpg2DSbzEJP1G
SnyO0tEwMHAn7sSEUZ+dv1aWp/8gyc+7NN6cnEa2gohLTMvKtGPf3LMleYmHrghX
22HLPBUHwOvme8MLd/OIISkG9QLlPNSM8YhO9gONSmAFBjKgUiVaj6l8m3954lfa
TyuwKT/hHVBlpYoq+AHnt/hTIsvJP9nlcYxvG9C4niTf3BhSS0Rf1q8k0y1oY1gX
9NzI1M9UpDt43KtOjWtOVbfRLMQKJmWn9H1y+dAB5szUw9JZ6Mw5yeVRnTz4E3W4
TfZFSGUXcPo=
=W/Qq
-----END PGP SIGNATURE-----

--=-aAqBNxXpbUMQCzstgQQq--
