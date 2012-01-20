Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2ATNiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:38:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51431 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2ATNiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:38:14 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: bq27x00_battery status report issue
Date: Fri, 20 Jan 2012 14:38:08 +0100
Message-ID: <3483637.Dq3EujObBh@pali>
User-Agent: KMail/4.8 rc2 (Linux/3.2.0-9-generic; KDE/4.7.97; x86_64; ; )
In-Reply-To: <CANOLnOOAwyM=Egzr_S8pUa=6iM=q8TU8jRJW_5nVrgqtqLHGxw@mail.gmail.com>
References: <CANOLnONB5m5iNbWy1=7WWN7T76S1vACbWtJu+KGyhqw2-cA3sw@mail.gmail.com> <10055259.ygSgKeUM8f@pali> <CANOLnOOAwyM=Egzr_S8pUa=6iM=q8TU8jRJW_5nVrgqtqLHGxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4961382.vFNTIT0ppH"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4961382.vFNTIT0ppH
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Friday 20 January 2012 13:02:46 Grazvydas Ignotas wrote:
> On Thu, Jan 19, 2012 at 12:56 PM, Pali Roh=E1r <pali.rohar@gmail.com>=
 wrote:
> > Now I do not have device with bq27500 chip for testing. I read data=
sheet
> > again and I think that your interpretation may be correct. Can you =
write
> > patch for this problem and test it?
>=20
> What about just reverting 270968c0984ae instead? I think my patch
> would look almost exactly like that..

Ok, then revert this commit.

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart4961382.vFNTIT0ppH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk8ZbkAACgkQi/DJPQPkQ1IT6ACeKw1JMeZJOHIVeXj8QTfe1WJZ
OSMAoMUi/Vmu3rodyu3+vXPGJcivYwoo
=eBHq
-----END PGP SIGNATURE-----

--nextPart4961382.vFNTIT0ppH--

