Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2GNE1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 00:27:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54958 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893Ab2GNE1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 00:27:19 -0400
Message-ID: <1342240026.25597.466.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to
 bnx2-mips-09-6.2.1b
From: Ben Hutchings <ben@decadent.org.uk>
To: Chris Webb <chris@arachsys.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Michael Chan <mchan@broadcom.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 14 Jul 2012 05:27:06 +0100
In-Reply-To: <20120713140907.GT13885@arachsys.com>
References: <20120713130405.GS13885@arachsys.com>
	 <1342186932.3265.8364.camel@edumazet-glaptop>
	 <20120713140907.GT13885@arachsys.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-R7TFhZeTM5qHrsCm7kMJ"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R7TFhZeTM5qHrsCm7kMJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-07-13 at 15:09 +0100, Chris Webb wrote:
> Eric Dumazet <eric.dumazet@gmail.com> writes:
>=20
> > Have you read firmware/README.AddingFirmware ?
>=20
> I hadn't, but now I have, and if firmware upgrades are considered 'adding
> new firmware', I agree this patch is wrong, and should have just removed =
the
> obsolete bnx2-mips-09-6.2.1a file that is no longer used by the bnx2 driv=
er.
>=20
> However, not having dealt with cards that need these kinds of horrible
> binary blobs before, I'm a little uncertain how I should be building
> upstream kernels with CONFIG_FIRMWARE_IN_KERNEL and pulling in the correc=
t
> blobs from a linux-firmware checkout.
>=20
> Is there a more automatic method than going through the source for each
> configured driver and setting CONFIG_EXTRA_FIRMWARE manually to list the
> relevant firmwares? Is there any way to give the kernel the location of
> linux-firmware and have it compile in everything needed for the selected
> drivers, as used to happen with the firmware/ subdirectory?
> CONFIG_EXTRA_FIRMWARE_DIR doesn't seem to do anything with
> CONFIG_EXTRA_FIRMWARE empty, so I don't think it does what I'm hoping?

I had a go at making CONFIG_FIRMWARE_IN_KERNEL pick the right blobs
automatically <http://thread.gmane.org/gmane.linux.kernel/1230462>, but
I couldn't get the Kbuild rules quite right.  No-one responded and I
haven't had another try since.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-R7TFhZeTM5qHrsCm7kMJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUAD1Gue/yOyVhhEJAQrj9BAAx/HaaO8uKPohxD5SNIa2jzhhWfcLcvsj
Lj2hQ0fKCTLN4v79klz+Nre6uSNwYREe7BXrEQdrtxT4JLR6SWX6xfb63JbF50P6
SlCHYFA6zYaqPYfN+gbqdSfTqdRHYOrI/nkLd3kKmsY17/4YF35pM7JmHsraEFKZ
8L38aEkyJ5mCPJQRYJXSLvXVHIhy8OcRFQ3H2I0nQIa1xQs64azNKoMGa8XOjobo
a/QEVK+Po7Ia4V1RIq19ciP6SAjYh97Nsgqlc0lIFWgkBoGrI0YnCgx4y1g821cs
s3g9qSmZm+7zKj/PZZE5OO7rWN+xZrU6akaEOoIx+SDr4WkvlEu62IuAc5s9CniL
a1AbRqA7nDA0dcIK9Nl0uQQuq6L+UaB9+w4kx9vRppMvC4p3284Y5GBv8CpzSneo
3isA6aztLVrH2RRH/wCmEwgaRI22DFm0kDIWZqLKQHyxf/eb3zb+V+4FnffT7+qN
FIZ7hIXv3mGITSUCsaTqjlOHjgaPib151ADCEhAAQyCNiFAqHqShHoSS++v9oxY6
ELQ4K7n0BsnFBfQtQWqLEVVCKI48xc4W6/MBXfg64jju/fe9Qfi2Jol46lcjOCxs
N5f1TDogZbN3QNvXNGKKvwbywIPsyRx+SNzCVVSYIFf78cOkHou5Jaoc/yG2RCQs
53RKSZMbOK0=
=/6Bs
-----END PGP SIGNATURE-----

--=-R7TFhZeTM5qHrsCm7kMJ--
