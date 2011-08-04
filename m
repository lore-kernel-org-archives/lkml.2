Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1HDGgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:36:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43741 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1HDGgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:36:39 -0400
Date: Thu, 4 Aug 2011 16:36:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
Message-Id: <20110804163629.e866b8f3052b7ac34dc83912@canb.auug.org.au>
In-Reply-To: <20110804142858.f7f2f128e5a038beb20aa87b@canb.auug.org.au>
References: <20110804142858.f7f2f128e5a038beb20aa87b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Aug_2011_16_36_29_+1000_oh2qPObbvnIYv2TP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Aug_2011_16_36_29_+1000_oh2qPObbvnIYv2TP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

On Thu, 4 Aug 2011 14:28:58 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>=20
> drivers/built-in.o: In function `of_alias_scan':
> (.init.text+0x6074): undefined reference to `early_init_dt_alloc_memory_a=
rch'
>=20
> Caused by commit 750f463a749e ("dt: add of_alias_scan and of_alias_get_id=
").
>=20
> I have reverted that patch for today.

And that commit has now gone into Linus' tree :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Aug_2011_16_36_29_+1000_oh2qPObbvnIYv2TP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOj3tAAoJEDMEi1NhKgbsHHoIAIOwTWE6JmxfetCTY5cXTq7b
TCBEt8ofp6rEX+ASx4YfICQiVkWn2lmD72xX2sHhgqcDdoTBoaFG6EJdR7hBdwQ9
FvnWnWHhz88AU8JcGB5Rrk7StYV4WT4GrCAQZQvlnz63PrvGOG1pC37+HiDePx9k
2sEaaPylIH4Sot0utOeAOOKBLWF1DJo2xmFvqusR//jTw/FTXhnuB3tgh2yyHzRQ
XSYm9M6SbidlWZft0O/F93dcmZlmO0dzYyuMy/FWI4s8SZgYMJeK3FNThRlkn7QW
1QRGaaWuKgW76uWfWpf4vb6iY7UgBwYQkJGf32ZnCOZd0EUihx0em15yXus1vv0=
=xyZ9
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Aug_2011_16_36_29_+1000_oh2qPObbvnIYv2TP--
