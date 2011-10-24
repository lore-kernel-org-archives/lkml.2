Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1JXJg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:36:28 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:36005 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1JXJg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:36:26 -0400
Date: Mon, 24 Oct 2011 20:36:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com, tj@kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (sparc,
 ptrace trees related)
Message-Id: <20111024203607.4e50ad20ab69e57b9faa96a5@canb.auug.org.au>
In-Reply-To: <20111014190950.GA10791@redhat.com>
References: <20111014180714.e11e15fd35dfaca839c6421e@canb.auug.org.au>
	<20111014.035459.2238341687770152474.davem@davemloft.net>
	<20111014190950.GA10791@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Oct_2011_20_36_07_+1100_japXhm9XV13.awww"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Oct_2011_20_36_07_+1100_japXhm9XV13.awww
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oleg,

On Fri, 14 Oct 2011 21:09:50 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 10/14, David Miller wrote:
> >
> > Now you guys are creating conflicts against those fixed up patches in
> > another non-sparc tree, and adding new kinds of build failures as
> > well.
> >
> > This doesn't work.
>=20
> Sorry David and Stephen.
>=20
> Stephen, could you please temporary remove ptrace from linux-next?

OK, I have removed it until you tell me otherwise.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Oct_2011_20_36_07_+1100_japXhm9XV13.awww
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpTGHAAoJEECxmPOUX5FElFcP/jOXKc6bmZxo0Hw6vj0ckM+r
iHjVgPV/I8obWL+0eaFGIlGpqRp86NcIWsgmQ0qpDCviEbs4ZLgjzGvLc5bargQq
CdLqIaW3zXEN41oer/QXPvogOsuPgOmDmAiOEH2CwsRdVUJKAIqseEFQj0llxug4
KGnuP7ywcPQpvi2M/Dn5x7iwb97XoimNhIvSXV+g4Ct8P1bAO3SZlJ7trlEOOyz6
/A+bzZ6jmZpDim5pM1UPGT9ztWqGd5YNogsTTYMGQJnnnjeKlGlIOdnNM8E2lQBf
UCsXmZlrd65oL+F7ZLLtPDyyTp0Q592tTQK9s4xGMzLudog8CFggz98cWYR7I0Xt
JTOiy6fLrP5wBbOx8yZpr5vgAaju0icvn+IKR093rNYvDUUvsGnl6xl/2qqlLBvl
txsH6Jkm6Z94V2caNvRjrcl1i91CHZR0whJIOBcFYvMSKgjclvsBCIEqxbQwPw93
bSr3EGvDcpe8RGnm422PjauiWriAk8aBk4Mmvmmlf2c9d3FaxZqchhH6i2QChC9b
GiT/xLtJLSpAu72rEXsJLIxojEoYVfevy2pBVWdaGRqOOYTgCaak5VMatJ+OPWU0
HbvfStZBoWltZFZRVDvdbrRrid2283274Hfjabis57r/9iU+Rn8Fm8Q8Z10HNR5O
qfYczfDMwrEBwzeYDKJ9
=WFAn
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Oct_2011_20_36_07_+1100_japXhm9XV13.awww--
