Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1JXJus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:50:48 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52663 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1JXJuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:50:46 -0400
Date: Mon, 24 Oct 2011 20:50:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: currently missing kernel devel trees
Message-Id: <20111024205028.42b236c4e318032d73317324@canb.auug.org.au>
In-Reply-To: <20111016211102.GA15720@infomag.iguana.be>
References: <20111013174358.b20fedb97c7b53db2ba82ff6@canb.auug.org.au>
	<20111016211102.GA15720@infomag.iguana.be>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Oct_2011_20_50_28_+1100_I_KtQjWWmafI4LiW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Oct_2011_20_50_28_+1100_I_KtQjWWmafI4LiW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

On Sun, 16 Oct 2011 23:11:02 +0200 Wim Van Sebroeck <wim@iguana.be> wrote:
>
> ...
> > watchdog
> ...
>=20
> Untill I have the time to do something new could you use the following tr=
ee and branch:
>=20
> git://www.linux-watchdog.org/linux-watchdog.git linux-next
>=20
> I started filling it with 5 patches allready, but still need to add some =
others in the next day.

OK, I have switched to using this.  Please let me know if/when you switch
back to kernel.org.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Oct_2011_20_50_28_+1100_I_KtQjWWmafI4LiW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpTTkAAoJEECxmPOUX5FEkYEQAIclG+DLjGQX90U0CVvutfzJ
E83vLE5SfS3g6tYVfEeF6dJInBZv18qrpaqRY4IGHMtSY+G8nmualzfOxRCFHKLj
fCfSAYk/cgMgZzaaIG062yxsIfh6ucBhlieSG0LRyEzTmA4cnRDJCY40YPnZ/3hY
B89k4ouVAqBiirZbaUGxDYn2K/jpmpHrNjayNcYYir5ziMv4EBJY4REIJi1qLbw9
KX902wJQtvgJGNMmRuPDPAMUWXOrj1+BIal642KO641lJdZ91Og4sHCzrGLyPrV3
QlpnbhpfuIHgvugWMHC2XWpQC9iYaTD9sjVzIHCVNK7l7vjW6Aus40iI0Wo4SvOO
f6k9tibgI0wCKeTZtTRQIdtTZof0skXXgsh9/r5Z084xQYhtTE4cHjIqaAfkNt9V
2wnZ642e95PtgoorGz9lTUeuKqpvOfBJI+A64Lw7PNbIjEso1qW6xYFGb7C7dCes
4HSkOAId8O2JWyKioYe6HXH/EBOp58Ps1/fCJ7zD7mNjndK5FEj1xkgRp1uC/HzW
AJQiEvwqyCK79L791SX0k5nx05WOJdx21i8OyyEUhJInjLVsDDN1lrFe98lcY/w5
WqNzee2vmgy8Tau4ZowBOmu8XKKMDlhEk557YwnbxWQDKZS01/gHom7yvZoHcd3b
XkIhaaOdVETB7x66W8RG
=bQd+
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Oct_2011_20_50_28_+1100_I_KtQjWWmafI4LiW--
