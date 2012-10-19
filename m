Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983Ab2JSDWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:22:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34090 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab2JSDV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:21:57 -0400
Date: Fri, 19 Oct 2012 14:21:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
Message-Id: <20121019142147.76f67505862afe5614167428@canb.auug.org.au>
In-Reply-To: <87fw5bp858.fsf@rustcorp.com.au>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
	<87txtso9xw.fsf@rustcorp.com.au>
	<CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
	<871ugwny1n.fsf@rustcorp.com.au>
	<CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
	<87fw5bp858.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Oct_2012_14_21_47_+1100_=V9OK0wiiNOqgf0p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Oct_2012_14_21_47_+1100_=V9OK0wiiNOqgf0p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Fri, 19 Oct 2012 11:53:15 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> > On Wed, Oct 17, 2012 at 10:34 PM, Rusty Russell <rusty@rustcorp.com.au>=
 wrote:
> >>
> >> Hacking the keyid and signer-name to be extracted every time by
> >> sign-file takes my modules_install time from 18.6 seconds to 19.1.  We=
'd
> >> get that back easily by making sign-file a perl script anyway; it calls
> >> out to perl 3 times already.
> >
> > Ok, that tiny slowdown seems worth the cleanup, especially if we'd get
> > it back from somebody re-writing it in perl.
> >
> > Want to sign off on the two patches, or put them in your git tree?
>=20
> Smerged them together: no point moving the x509keyid script now.
> I dropped the optional dst arg, since we don't use it.

So, this still generates the keys during the normal build, right?  That
would be a problem for build servers that have limited randomness
available to them, I think.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__19_Oct_2012_14_21_47_+1100_=V9OK0wiiNOqgf0p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQgMdLAAoJEECxmPOUX5FEBOAQAI+juo8/EGbhLDW7gT7E/h94
Ml4xaZ3kdxgIh7uVc/DRPwMCN5qNO+cjj8cLi4xwNCcATBfdmSAzLCqJVjYrFhDB
pVIaljDYe3IbEeAhSrxGPX6roKqFyRtDLyj7VceMDaokm+5Gzzr/6Li80LOEvd6q
N3KZOZHAN9WXeAwJjY3kUcwrFDccedexK4BboifFWGZFnNdegzQOuCIEWjUQJoGj
CwdcVHmEbUVxTgusW+OVGuTJyHsUhGGD7DKOVX8eiqyE2nfWDsidu2QfnDRAC74l
e+yuEkvAXzRMvumkfc/WKtqZEmSJ26uXlFi27mjZRIqge2F4cSAcG9oeqCcpGBez
U/WNOdYCpkHZr4+c9yiBqGW2LhcDXeVNpWYvNPxvrSvh1szhgFyZz8FMk+vHlo2q
yGk6pKG+tjhAFNACaEpfwVLY4RdS+oI5FkZLLJ7RumuSJH3lFXF7QUP+fyldsEWZ
6JLqLeG+sgiatFTKczeW4Hxsp0GsGVDOs/JfGIeJv9auVtHbda8uqKI15rtblJVp
tVtzhw5Qn0myVTWIAOlkLPzDTjjTgsois2wXqNaVDA8lvXhAXWCClVG7qaAuvLx0
4Xz7oqwSi4cb9w6Rawa4+l3qoe9DMdJNwGFINBq9BTDkuvJDRpLfiSdpkFPksWqW
EltktB9VKEcY22gPrfiZ
=Epkc
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Oct_2012_14_21_47_+1100_=V9OK0wiiNOqgf0p--
