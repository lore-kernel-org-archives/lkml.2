Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1KOKSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:18:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab1KOKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:18:41 -0500
Date: Tue, 15 Nov 2011 11:18:17 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Purdie <rpurdie@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: Re: ARCH_PXA_ADX
Message-ID: <20111115101817.GA6907@avionic-0098.mockup.avionic-design.de>
References: <1321351777.20271.166.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1321351777.20271.166.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:xvmSYH9wAvTOp/s+ZtYa1Txzao9EJnOb/cOY5skMwq0
 Bj85fnzvmGNm1bUFv0Upu5YuCI4Hjy5YKEqr7cwbyl7MOjrvZm
 2A5bAOzXmWOKwjx3RC2olffq6Xlvm9qQJ51SuO5BOJTjumAjkN
 wxYkvx8dbCW+Cfeeq/BBmhpmlTqCYAhAlOXp3Mz3TuEMFpfl4q
 ukTWIwq+Bqv/MpEQ/P+ZosRh2cUmu7Qr1POkkmVqWBfS/Px44Z
 urDJd2qxrz0s+TAW/RrZN3BtL1gocpfj6B70KeOrUNK5Qu6NdQ
 sfKCFU9zfvG2LnQD0p8MRL9niLwdSUgngyKxxSw0soP36XzGVz
 G41T4AxF9XxuU4vCA9N4fhqllIAegGMYM1zGcA0PA9+EXz8uIh
 9QNsRQVzqoljxXIO6oX/+qrhOkVjHoM6i8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Paul Bolle wrote:
> 0) Since v2.6.32 the mainline tree supports the "Avionic Design Xanthos
> Backlight Driver" (BACKLIGHT_ADX) and the "Avionic Design Xanthos
> watchdog" driver (ADX_WATCHDOG). These were added in commit 3b96ea9ef8
> ("[...] Add support for the Avionic Design Xanthos backlight device.")
> and 38461c5c08 ("[...] Add support for the Avionic Design Xanthos
> watchdog timer.").
>=20
> 1) Both drivers' Kconfig symbols depend on the Kconfig symbol
> ARCH_PXA_ADX. At that time this symbol didn't exist. It still doesn't. I
> haven't been able to find anything remotely related (ie, I even did
> things like "git grep -i PXA | grep -i ADX").
>=20
> 2) So it seems these two drivers could never have been built from the
> mainline tree. (I'm starting to think that the config tools should
> somehow check stuff like this.)
>=20
> 3) Is the above correct? If it is, why shouldn't I submit the trivial
> patch to remove both these drivers?

Yes, all of that is correct. Unfortunately, I never got around to mainlining
the rest of the code. Feel free to remove both drivers and add my Acked-by.

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7CPGkACgkQZ+BJyKLjJp85WwCdFGR3lGZIRT1pKsvfd1wEN3aB
0hYAn2f9jAKqfqBcRJHqTJ68Ja1Oq/R7
=GAl7
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
