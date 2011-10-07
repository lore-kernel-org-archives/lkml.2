Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab1JGAqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 20:46:04 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:39463 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab1JGAqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 20:46:03 -0400
Date: Fri, 7 Oct 2011 11:45:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bio: use a static inline function for
 bio_integrity_clone
Message-Id: <20111007114548.e003f8b1d62cb81eb2fe6096@canb.auug.org.au>
In-Reply-To: <20111006162219.b629eabb.akpm@linux-foundation.org>
References: <20110826120900.cdc6e4c3597c88ad45015a9b@canb.auug.org.au>
	<20111006162219.b629eabb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Oct_2011_11_45_48_+1100_9lKIeXndi0Dv.xgS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Oct_2011_11_45_48_+1100_9lKIeXndi0Dv.xgS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 6 Oct 2011 16:22:19 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> grumble@lazybones.  All those other vile macros should be similarly
> converted, for this reason and for all the others.
>=20
> Am too lazy to do it myself, so let's at least fix this warning until
> some others turn up.

That was my feeling as well.  I will apply this to (the akpm part of)
linux-next today (since you have added it to the -mm tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Oct_2011_11_45_48_+1100_9lKIeXndi0Dv.xgS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjku8AAoJEECxmPOUX5FEDWkP/RGa3e4mngfL3uWBtFWuK0S+
YKWEScxh2Ip4+0O/gu9dKl6FRAXPcTgzZc6hA74VDgmT0IBGUqhBtaLc+axPX3ql
DNGnNaxDLrTNOirT8IpmRUTJGcpbtMdldJZ75WqLu8ZApBjcGJIcczvpoZH2tkpR
knliVZm00+7NpMQmJWZuHZTP8XdkwS0wOhgzg5MsNofyPGssuFZnuW1SkFt2M1WY
YUL8Bpclq1VFktdA1dRsTECVKHlsJdERJk1/6wUL7//acHhpz3jqtD7MncuIekJb
pXQrFR4cFDrImwPSk9I6O2Qqs4X8ERFte7HIckW6t8Ac0NjLCavEcyHNEs2dpHr9
c0RtsAcVUmdN9sK8SmVMl6nLGQWfbBgSzrfmIde9G4qfr+dDpUAPsixgOnc9juy0
q9gIrhjtzKTm0PePwGPS1lQMoO53pZ1bzrC9lgIKb/G68usrr7rJx3v5V4lGWWFS
cgLI74yc5112Ay1B5eQd9ziqE9kfmZSXxk43PNuHONXT+zHcrwzsXccK9uI5Oa3M
pZJebNBixGQqz5Q0BmNtLpn5EXVloOdewzWGSOQ7isD0n3UUpN/rWbC+S+HS8Qlr
aG72i6CLg3vVp146qXO7LccpA7maTmB0dOyJe/2JU2aaJf7wFHJdpf56E8zl1Qan
/L7WFyCOSz5wXuWaDUXg
=5fzU
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Oct_2011_11_45_48_+1100_9lKIeXndi0Dv.xgS--
