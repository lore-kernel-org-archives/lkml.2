Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab0DDH0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 03:26:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48512 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0DDH0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 03:26:13 -0400
Date: Sun, 4 Apr 2010 17:26:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca
Subject: Re: linux-next: build warning after merge of the tree
Message-Id: <20100404172605.098eb8ad.sfr@canb.auug.org.au>
In-Reply-To: <20100328.185707.161194820.davem@davemloft.net>
References: <20100329103139.1a735227.sfr@canb.auug.org.au>
	<20100328.185707.161194820.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__4_Apr_2010_17_26_05_+1000_ouKpu5uhsFq5sqW+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__4_Apr_2010_17_26_05_+1000_ouKpu5uhsFq5sqW+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 28 Mar 2010 18:57:07 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> Strange, it didn't warn here.
>=20
> I just committed the following, let me know if it fixes
> this.

Yeah, that did it, thanks

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__4_Apr_2010_17_26_05_+1000_ouKpu5uhsFq5sqW+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku4Pw0ACgkQjjKRsyhoI8zU5ACdGMLv3IV3wVDr0W4XvCF2S9KD
VpwAoK6flZ40PViuzZuh/TD2on9axKtf
=omtc
-----END PGP SIGNATURE-----

--Signature=_Sun__4_Apr_2010_17_26_05_+1000_ouKpu5uhsFq5sqW+--
