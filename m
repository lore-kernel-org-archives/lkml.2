Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2IYEuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:50:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54484 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2IYEuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:50:19 -0400
Date: Tue, 25 Sep 2012 14:50:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: NeilBrown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the md tree
Message-Id: <20120925145010.621ed466daec9e5e4f1d9ddd@canb.auug.org.au>
In-Reply-To: <20120925141005.2a83593e@notabene.brown>
References: <20120925133146.36615871cf4ccbcbd422ed87@canb.auug.org.au>
	<20120925141005.2a83593e@notabene.brown>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_14_50_10_+1000_Tq0dminTPGoXw+_o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_14_50_10_+1000_Tq0dminTPGoXw+_o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

On Tue, 25 Sep 2012 14:10:05 +1000 NeilBrown <neilb@suse.de> wrote:
>
> I requires the following which I have already sent to Jens Axboe.
> I might pull my patch until this fix-up is resolve.

Or just ask Jens if you can submit that patch through your tree (with his
Ack) since you are the one who needs it?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_14_50_10_+1000_Tq0dminTPGoXw+_o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYTgCAAoJEECxmPOUX5FEv1gP/RmTURhDWQ+aNntQNbgzfwg9
4zCbLF1GaVcxeuRDJ5di+H4mqTsz0rOMmiXld9d97fS1oxoZNzReXrLBC/AYECi0
I6+l5jlkMOm301PX7MEdbuL+cIT767jEqYGAeBuEXsUkEwKoGOccCgbH9G/ppT5v
VzZzo2OLQDomaM6co0QxpY0vmcIfMagkNtyk1/FAuGAJQFZhf2pRdBYFEZC1QyEu
HchwBedZjH0aNYnvGWg9jku0KVzGu3YY6v6P8TVtZo8Eq6igCeCUfJD1Ir7NUg/f
pwXS+NTYo59yZmB/uDPMtke1YdeDD6/hLE5RR6TtdPV63aJW6xb/AapdPd9Hmm/o
C8+Z3kalQzjQ8EBmJzsQ/Mpjs1rr1LfMDMpSqT7mEkNOKMZOguloKa27rl8WVkxZ
OX7flCXkOY4KZCfjhnPEfFHrRkzi/CmHV1sTMY+J7RWs6WFA1dIbPz+R49ohGzvb
TyAShdj4XIzpFWzQnU4f21aKrfBssaDQ6JUHiamP636kFmunaeLXeqZ8xiF0gIX9
jCAuwDqMTgOXzDMHlfit2HaT0FBzBK+6pa8tvjbSgnrTKo9lRtnMsnvfPnhocEEu
Fww+luxHCagQtQBF6Otk2QDM0F3IEv3LHWOR0wWVcr6lPuAtaPihzU8EFhxUY1xI
0kcs/LkF5+17HpPNCbfX
=+oCX
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_14_50_10_+1000_Tq0dminTPGoXw+_o--
