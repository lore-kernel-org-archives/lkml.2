Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1JEBGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:06:33 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:56750 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab1JEBGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:06:31 -0400
Date: Wed, 5 Oct 2011 12:06:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: Changed location for arm-lpae/for-next
Message-Id: <20111005120621.46c24fe4b8f83ac78944b777@canb.auug.org.au>
In-Reply-To: <20111004132614.GA13865@e102109-lin.cambridge.arm.com>
References: <20111004132614.GA13865@e102109-lin.cambridge.arm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Oct_2011_12_06_21_+1100_sq4TKZ7QRRKSxc6O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_12_06_21_+1100_sq4TKZ7QRRKSxc6O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

On Tue, 4 Oct 2011 14:26:14 +0100 Catalin Marinas <catalin.marinas@arm.com>=
 wrote:
>
> Since I don't know when I'll get my account back on kernel.org, I
> re-instated my tree on linux-arm.org. Could you please pull this tree
> instead of arm-lpae/for-next:
>=20
>   git://linux-arm.org/linux-2.6.git for-next

OK, I have switched to that from today.  However, that site is also
inaccessible today :-(

> BTW, you could name it catalin/for-next or something else rather than
> arm-lpae as I have some kmemleak patches in there as well (I could split
> the patches in two branches if you'd prefer).

I would prefer that you split the kmemleak patches out into a separate
tree or branch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Oct_2011_12_06_21_+1100_sq4TKZ7QRRKSxc6O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOi62NAAoJEECxmPOUX5FEif8P/0sa3tCEDtVnrL02FNFabey1
C7BBG4EMXt8LHmPjBhELs2ZZFrIfjmKxGnG4j4Oox4w6jO2NlMmXcq9RDI4cSUJi
A9Iyflyf794QOkBXrWcLJ9iOxE8Wo81qsu6bioEKVxXM5gnWCmIQhIMJbrPQ3AFA
2FoaTfymZLN6FfZnU1AU0ax6UWyNW7C/nUBNOHFxlqR16zoQdq9wdg4xavAujXKl
Gr+eg9/65g4OWt7HgRvTxrXv3w72F49YJOi8yA576EjvnQMUy9k5WTDq1pWoqs5u
hZ4u+GvVGr3BXjBtg7CHN6FTTpRK9+TViVWUlyxAeCYhU8JMY4NmzfclHeBBAALi
kr7Y+2DpEx8zrCpzVygMz8Ms/EhNVg9bHB9qv2deBAZy3O9Tc3Y3n9CfBvSBL4td
qHsjGMSpj/e+IkCFaemprUj4QF+IbhxK62gFr0RIpdtL6F/yFJ7ZpGe8P3oBr9v6
NK4kBUhyb9MqwU95D1iLfopa1BKZWHllYhzDS/SbXZjNxNGXdVfcj2fJLxy7zjo7
MWLaw6HHgXYXCjN9TkvFWiT5wbuOmgzYZETuEEat2veLJhBsQfUdgPSOPNwgOWjM
YKnf7e/+I9hddtrlDYdiQ7B8n+xsAACr3Jx3phVDdnFKwJSj9HKomis+f2KAqUZW
spYaUoFJcDUK4ehC18FW
=vHD3
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_12_06_21_+1100_sq4TKZ7QRRKSxc6O--
