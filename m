Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0LFUWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:22:05 -0500
Received: from vps.mortis.eu ([79.99.135.181]:58733 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab0LFUWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:22:04 -0500
Date: Mon, 6 Dec 2010 21:21:55 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Michel Arboi <michel@arboi.fr.eu.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch for Fintek F71869 watchdoh
Message-ID: <20101206202155.GB3188@salidar.me.mortis.eu>
References: <4CFCB76D.2060405@redhat.com>
 <20101206191930.GA3188@salidar.me.mortis.eu>
 <20101206205345.639f31bb@marmite>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <20101206205345.639f31bb@marmite>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2010 at 20:53:45 +0100, Michel Arboi wrote:
> On Mon, 6 Dec 2010 20:19:30 +0100 Giel van Schijndel <me@mortis.eu> wrote:
>> Please insert that constant in the list of other Chipset ID's
>> alphabetically sorted (to keep that list consistent).
>=20
> Like this?

Aye, looks good.

Acked-By: Giel van Schijndel <me@mortis.eu>

>> The rest of that patch looks fine.  So if you perform the above
>> modification you'll get my Ack.
>=20
> Please note that this was just a quick hack. My basic tests showed
> that the board did not reboot by itself, and it rebooted when I
> stopped the watchdog process.

That's intended behaviour and probably sufficient for testing.  Most of
the behaviour isn't chip-specific, only the initialisation and
configuration of the chip is specific to that chip AFAIK.

> I downloaded the chip datasheet from Fintek's site but could not make
> much sense out of it. It is rather terse.

Yes, those datasheets can easily give you a headache when you're trying
to make sense of them.

PS You might want to include patches inline (i.e. as part of the message
   text) as that's standard procedure for Linux MLs.  That allows easy
   reviewing and commenting on patches.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"Always code as if the guy who ends up maintaining your code will be a
 violent psychopath who knows where you live."
  -- Rick Osborne

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkz9ReEACgkQZBYm/87l50JSpACfROmaUeGAuQHrIUFUgOJVDGnY
2+kAoK/dq8ahLyLTx3/3TiinB1992hyF
=LuYv
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
