Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2FYW71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:59:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34593 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2FYW7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:59:25 -0400
Date: Tue, 26 Jun 2012 08:59:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120626085921.12473c20151e724ee0c8ac91@canb.auug.org.au>
In-Reply-To: <20120625164049.GO5042@outflux.net>
References: <20120625164141.1c5b1b543e0309005dfd0d9c@canb.auug.org.au>
	<20120625164049.GO5042@outflux.net>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Jun_2012_08_59_21_+1000_XFTgaQhLgArzUYeB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jun_2012_08_59_21_+1000_XFTgaQhLgArzUYeB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kees,

On Mon, 25 Jun 2012 09:40:49 -0700 Kees Cook <keescook@chromium.org> wrote:
>
> It looks like namei.c changed the logic of the lookup loop. This should
> fix it.

OK, I have folded that into the original patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Jun_2012_08_59_21_+1000_XFTgaQhLgArzUYeB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6O1JAAoJEECxmPOUX5FEN/EP/3CnmeK3mQ86ve/t7wIjymKA
lCo6GG9xUYz471CkzKLpHz/S+BCD1ppY4fuwtz+lJ0PSLTsf4vQxcfZWNiCett42
fwIWAU7MEMfhQoYY1EfRkiFAXBzqL/pC03pqaPeUy+S/VhF59bVrBqaihISpYdxN
maTNQ9SyfDs+cg/G+cj1aJXos+YtJFxDqYQOxIe7S8lnw5DeNTxCR4vvW6jz6i1w
lf2uezcYdh1/XMccev5b1cloX78IfiZVJTvBqTtFo4LRtm3ncl2tRJdcD+aS9DWm
YqrsUhvh57XJ+c7pNh7yfDH2Qj5RozmzA20su0HyLALvHv7ThvaLSFqJ9r9Vagdv
BICsTpNt3POTybLFk48Nl3SSd79T8NWFmpHGk6Up2wK0AkWRQ1wWSUjGz1z2ibjL
b5BCCsf381jCh8VHzSRctJRmmnpGdf0nosQfZw2PCOFGw6XMb9E1v2ROrK10eDhE
lqvWTMvo0mKTVND9et27Vg76DUN58YmLtPRO/K7baIoSdEb02vmy+E09/BLby01J
vmg8GCIRjs1D3CnfdZMANtEfH50zXu+jZ4kjQm6wAA/Tb/EbDf/eoWrmbTunRJ8z
5nO9iIfD7CebJRS8Pxt43FrLU9CeRAo3wueZkzqm5pujr2BNlvTIMQWfUg5kNPIs
JzUDuwiLNoKusxFUVQEW
=F8l+
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jun_2012_08_59_21_+1000_XFTgaQhLgArzUYeB--
