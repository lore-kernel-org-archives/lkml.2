Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2IPQdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 12:33:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58326 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab2IPQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 12:33:17 -0400
Message-ID: <1347813183.13258.286.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 16/46] NFSv4.1: Remove a bogus BUG_ON() in
 nfs4_layoutreturn_done
From: Ben Hutchings <ben@decadent.org.uk>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Boaz Harrosh <bharrosh@panasas.com>,
        Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 16 Sep 2012 17:33:03 +0100
In-Reply-To: <20120912233819.364182315@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
	 <20120912233819.364182315@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OfdHrFMI0FWKNYaP/j8Q"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OfdHrFMI0FWKNYaP/j8Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-12 at 16:39 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
>=20
> commit 47fbf7976e0b7d9dcdd799e2a1baba19064d9631 upstream.
>=20
> Ever since commit 0a57cdac3f (NFSv4.1 send layoutreturn to fence
> disconnected data server) we've been sending layoutreturn calls
> while there is potentially still outstanding I/O to the data
> servers. The reason we do this is to avoid races between replayed
> writes to the MDS and the original writes to the DS.
>=20
> When this happens, the BUG_ON() in nfs4_layoutreturn_done can
> be triggered because it assumes that we would never call
> layoutreturn without knowing that all I/O to the DS is
> finished. The fix is to remove the BUG_ON() now that the
> assumptions behind the test are obsolete.
>=20
> Reported-by: Boaz Harrosh <bharrosh@panasas.com>
> Reported-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

The upstream commit has:

    Cc: stable@vger.kernel.org [>=3D3.5]

and so I ignored it for 3.2.  Is it actually needed for the earlier
stable series?

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-OfdHrFMI0FWKNYaP/j8Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFX/P+e/yOyVhhEJAQoY9hAAlgPO5HE961HAoP/c6CYnP4otXDPk1BN7
YNewKRH4dG/cfveOXg5DSk4c5en+osfhRKvUrcGikGgLc2LN3uUYelH9n4i8jg5g
ggdKnltPoYDxId9BY7Amvt8AVhuTZLFUulHxKfP6rkSPZzTZcHO37BXTuZoxgkPq
rJ2sCT9WE7W6jI2Djjd1QhymArj407U26TAznqM066+Q4Z9vBkaVfSokNpqH/SxJ
OfwG/+kKSq1OPE893BBKc8qukO7iiv+vqjLV7if/FsRT78FwCz3NZeBQtAsIzVgV
efZSGwxPScynrEL+HD9NTFhSC5Juhn3BHj8zpzBHmU6gSVi9VHqFQBcuCrQtJeTN
R0dAP7jXbQ0jMb3QZcBtEJFQSNSzaEvs4CfH18V0LjY8V05NNqdhbc+i3neMMIQO
FKPTaP1JKvYpypvUfBtvcV3Idpd1nuppnsRj/mnKCEyjtzZ8dDPGlqxI/gWSEVL/
DjubfrjP4+Ah1jhBZSm26K4QrVPcSMcCsyOlBxIgCo9ilZPtGjYetO26pcKoOFgF
prLAdogn73c0I/VU6NMev9KNNfkQHyEeePZgC7rwwHftlwP71xTMuUiXcGIMaeph
po9CL5iFZOpuejRp5H50pQAuRQnz3YxCGTTQkhKzadYpHrwSXjYt5d8+5Q5gqRLQ
9bkNBLvwBb8=
=cZKC
-----END PGP SIGNATURE-----

--=-OfdHrFMI0FWKNYaP/j8Q--
