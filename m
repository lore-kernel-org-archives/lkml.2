Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2DPNqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:46:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46985 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600Ab2DPNqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:46:12 -0400
Message-ID: <1334583961.3209.112.camel@deadeye>
Subject: Re: amilo-rfkill: unsupported platform
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 16 Apr 2012 14:46:01 +0100
In-Reply-To: <20120416131216.GA4047@zeus>
References: <20120416131216.GA4047@zeus>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/hr46n5cz0CwQ9v2+aH6"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/hr46n5cz0CwQ9v2+aH6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-16 at 14:12 +0100, Luis Henriques wrote:
> Hi Ben,
>=20
> You have recently submitted a new rfkill driver for the Amilo A1655 and
> M7440 models.  We have been using the fsam7400 driver[1] for the Amilo
> M7440 and it would probably make sense to merge it into the amilo-rfkill.
>=20
> However, the fsam7400 driver directly invokes BIOS code in order to turn
> on/off the radio, instead of the methods used by the A1655 and M7440
> driver.

Consistency, it's a wonderful thing.

> This means the memory pages with the BIOS code would need to be
> set as executable after the ioremap (which is probably a bad idea).
>=20
> Are there any plans of merging this driver into the amilo-rfkill driver?

I have no plans for this, but feel free to try it.

Ben.

> [1] http://www.iragan.com/linux/fsam7400/

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-/hr46n5cz0CwQ9v2+aH6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT4wimee/yOyVhhEJAQoNhRAAvAEDxuxiLOympGJqKWwT10+jpO2p+9De
Wk3BoaQw6BpWgvVS+WVSgG7mEL2YEPk8CZxHi/JIrDIqdHeNvF9CqYnx4svK55zp
dVqn3NfgOPDZL9qHsLykCqZAMsbetDX3ihqfyM5Ic/dc29uvvH98lmiEkkQQRbbr
qo04pJ9wwmwsF7MgkOhbNirhnjiMSBf7KXC1PUrLmCZWTNU9q6XqwzY0NYcmTV2G
9oWwsatJxnZ+yhnnnluXX/6Z8khaCUOuX4orqxOr7cilOHUNHsp+xljWhLa1jBnO
iCN5F8Lk38RlbCLZi3bfTMMqr3dt8ba/riYT2idrfCxqMom45nER5hnSZBYk9Hz2
f/4hzY0tVPQ70sJ7xNuIbe/ME3xzCcXlKtMIHjXZYGWKcRfmXA+6oK1RrTJjkXOt
Cduai98zW2r0m9J/Afao9/Ous1g8CPCwWsdvf8VarJFylCocgJ5T7LjBlP+Acwdy
qgYh6Pky+2oiibYtHPtAaxGgDCiH8dX6bEwZju0Yz42loPyxX7UIjSS48/Ejqp0Z
vXqP3UJAaF/dRGVM1A+rASXJXdZcqZAER33BWK4dR0a2kLx95Ol4OSuR4FFpjnZz
+MIsKwgk6HAVWpXulTwb1wdAChXvawo1C38jcsJTmdob2W7zAOk9LucFXcjLaIyG
pvVhsiXfT0c=
=3Ct7
-----END PGP SIGNATURE-----

--=-/hr46n5cz0CwQ9v2+aH6--
