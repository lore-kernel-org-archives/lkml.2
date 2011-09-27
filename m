Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1I0XPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:15:51 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55215 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1I0XPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:15:50 -0400
Date: Wed, 28 Sep 2011 09:15:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 00/24] C6X: New architecture
Message-Id: <20110928091542.9b1e35afa2075106550de7be@canb.auug.org.au>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Sep_2011_09_15_42_+1000_.9MlTJr0TDCvg.NW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Sep_2011_09_15_42_+1000_.9MlTJr0TDCvg.NW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 16:29:41 -0400 Mark Salter <msalter@redhat.com> wrote:
>
> Here is v3 of the C6X architecture patch series. Patches are
> available in 'upstream-v3' branch at:
>=20
>     git@linux-c6x.org:/git/projects/linux-c6x-upstreaming

Is it time for this to be included in linux-next (i.e. are you intending
to send this to Linus during the next merge window)?  If so, please send
a request (cc'd to here, linux-next and linux-kernel) asking for
inclusion.  I would prefer a publically fetchable tree (the tree above is
(implicitly) fetched over ssh and is so not generally available) and
branch name that does not change over time (like "for-next" or something)
but it can just be an alias for the above.

Arnd, do you have an opinion on this?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Sep_2011_09_15_42_+1000_.9MlTJr0TDCvg.NW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOglkeAAoJEDMEi1NhKgbsa0MH/3cDHuENZ5q8jJL3h52zr7zW
snrxT8XwkgBqPwdKdGymmvHIVqC6ZdCiocznA873WLrx4D6l639Eyq3I7OW588TP
MztUKA85b9Z4C8h2g/9LTupZIqpsoq7CzcT86y99q79R3V75m/VBP4WVNQ9VzYFy
P02nnKe32QrmadEwazUwm+m51RY9BykW6EOQj0i12EPc/grIQJsm2t9S4w+zwvWZ
ySBo9VzaaEJuZgesCCSXQ6YA/q+S5gFYBm3hIm3TY7cvhwZm56Lp71MaqCdj2bbF
jMV8msUrifAugF85zeRbH+J0Ieei6Smbx2aRXJZBdlmkMONh6FkAdzg+gV3pcBg=
=N2+k
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Sep_2011_09_15_42_+1000_.9MlTJr0TDCvg.NW--
