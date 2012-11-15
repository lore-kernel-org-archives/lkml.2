Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768888Ab2KOUBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:01:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42620 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1768435Ab2KOUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:01:37 -0500
Message-ID: <1353009686.4867.66.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Re : Re: Sound+USB: deadlock problem
From: Ben Hutchings <ben@decadent.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Date: Thu, 15 Nov 2012 20:01:26 +0000
In-Reply-To: <s5htxsskz6a.wl%tiwai@suse.de>
References: <50A20429.3020109@suse.cz> <s5ha9ulx5xe.wl%tiwai@suse.de>
	 <50A20512.10805@suse.cz> <s5h7gppx568.wl%tiwai@suse.de>
	 <50A21542.2090102@suse.cz> <s5hy5i5iz97.wl%tiwai@suse.de>
	 <50A3761C.6090101@parrot.com> <s5htxsskz6a.wl%tiwai@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BpwED8h7Px9F5OInOUoB"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BpwED8h7Px9F5OInOUoB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-14 at 15:59 +0100, Takashi Iwai wrote:
> At Wed, 14 Nov 2012 11:44:44 +0100,
> Matthieu CASTET wrote:
> >=20
> > A deadlock was detected with this patch. You need the following patch [=
1]
>=20
> I'm going to send a pull request including this fix commit to Linus
> tomorrow.

Since this is now upstream, I've added it to the queue.  Thanks all.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-BpwED8h7Px9F5OInOUoB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKVKFue/yOyVhhEJAQoa+A//Z+LOSlpKqDE50AOkS1rBwg018FCK0TLg
mHWwuah+yo6+TyP4v7DTd6e1fz6IfZW5pjduC6yxgF1pv3bk1yflIcjOSAL/fP2Y
WmgNWdF2eJUuFXakPXffgc3XXMt0zUa0H6CGtrlTlxILeroVON72R1l5g5KxkyBV
zixnOwzmhjx2uXNyVNfG9T/ZsMrEARumdSY+d3NodwOb+exIbIvL9vItGFQ0TzbZ
bPGBYowcQPMAOVcWkIA118v3fBc1uwtpNehbovc1zyssxAvVrBxAywyHZ9wd/WWd
fmist11YsjVVaHYXqBITHCHaS0RmOJwEk4/te29ulTl4P3qJrq413UaUhB+7Onno
Y00Vb15Ob/LE88vMxPTKnJng20ttyMcNUJybGxcXfxI51jF4hVLEkCZKq+8VHQ7i
5hcE84CyN/qYAHoym1kcpRt1VfAIH3U2XYlsljHLJHeD1W5KjFDiKzUbO8Evb0ac
GM4g85lAOpWSysv2B5RPqbTlSWNrcOmSNAuYMq3G2CgTIwWFurFr3UV6b1LwMBvQ
otmBKfORRq8/P4I71Z/khK8W8hxULe0A0StZ93kOlDVx6WLqhRS6/eGZPx086jWo
xE5/2WrKm5wyn2PI2yNk1lv4Q7Am9W31qDOdirxnCUwr1gktakFXn5VxV0cMXpGT
yz6DToozRpk=
=6h+U
-----END PGP SIGNATURE-----

--=-BpwED8h7Px9F5OInOUoB--
