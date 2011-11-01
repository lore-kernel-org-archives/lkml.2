Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1KAJEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:04:06 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51196 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab1KAJEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:04:04 -0400
Date: Tue, 1 Nov 2011 20:03:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.de>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20111101200355.52daf4662050ed7ad6b67cfa@canb.auug.org.au>
In-Reply-To: <4EAFA949.5060200@kernel.dk>
References: <20111101161500.79aebe8d8f30162ea542a818@canb.auug.org.au>
	<4EAFA949.5060200@kernel.dk>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_20_03_55_+1100_C7YfbfslR0aICgXe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_20_03_55_+1100_C7YfbfslR0aICgXe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Tue, 01 Nov 2011 09:09:45 +0100 Jens Axboe <axboe@kernel.dk> wrote:
>
> Fixup looks good, however don't you get the same conflict in basically
> all the raid personalities? Fixup is indeed just the simple int -> void
> transition, conflict is because of the mddev_t -> struct mddev change
> that is now in Linus' tree.

I got these conflicts in all the raid personalities a while ago.  I am
not sure why this turned up for just raid10 again.

> I'll push my pending off to Linus today or tomorrow, so this will be
> resolved shortly.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_20_03_55_+1100_C7YfbfslR0aICgXe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr7X7AAoJEECxmPOUX5FE57cQAJNRu7v3m3LXDCWDY7cnAjs8
Pw8jA3zORDGmsJC0YzlSYXMT3SicppcL3FvlBQ0/6rJNvCDY6XnzH2N2HAo55WXG
z0vChewPSG3VWqzb+xmCDosZL4OcYm54hb/8NQ/sOxcgINVQU8583/e8iwryhLxN
D2zmMt6dYcmI6NEjDMyb1wAImXYJUAMHrkNVL4bLHF0EBCv2mnP5XpC7jCG/DLP2
Y7caMdnzm6F3BbbnvFmh1gqyxGqAb2tVex3jfwsLADROsqacCtYOEs74K4T6NERT
sru8jnhqtkAe7PFUstmUKn8kdkuKTdVuG+2cDydI5NFxxpmprlCdnXOacPQp36Wa
Ef0H+qhbAFArSNnaKAANCqiWVcLRrzbEkIy8c5HOtAoGyadujgpWtTxulf7toHlN
wEc7A6YIQyURmCr78fkNaGGsJqOV9szHCJLSCjanCeUzpaDgU++Dmk5MBFGXfReD
FwYFu9zcv3867fnrG3u04nXHe9AU8hXCxzowAFaPfixLSTUKMiUxlf/SNWdklQeI
arXm9HKLjqw0D6Z4f8GG6fr+GxHQL4pDYHHgh9hnECuvIxE6EvT0183VKk8chh9E
1zeVLr9ykoSHaiPz7suEG7EQo8/YvuNei+0gIASyyI1dwRebUhcXs6r8q/lNjPqt
crfVwiNnmA3tmW3YKeSB
=Fk6T
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_20_03_55_+1100_C7YfbfslR0aICgXe--
