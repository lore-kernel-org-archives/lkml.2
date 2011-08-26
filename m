Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1HZFe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:34:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35211 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab1HZFe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:34:27 -0400
Date: Fri, 26 Aug 2011 15:34:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Gibson <dwg@au1.ibm.com>
Cc: jdl@jdl.com, John Bonesio <bones@secretlab.ca>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH] dtc: remove some warnings
Message-Id: <20110826153418.117232466509fc941f753b19@canb.auug.org.au>
In-Reply-To: <20110826044902.GJ2308@yookeroo.fritz.box>
References: <20110826112643.f86132d55edc5d452df3ebd0@canb.auug.org.au>
	<20110826044902.GJ2308@yookeroo.fritz.box>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Aug_2011_15_34_18_+1000_ULqGI3.4e=atEdWr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Aug_2011_15_34_18_+1000_ULqGI3.4e=atEdWr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, 26 Aug 2011 14:49:02 +1000 David Gibson <dwg@au1.ibm.com> wrote:
>
> Jon, please apply.  Uh.. except that this is a patch against the in
> kernel dtc, rather than upstream.

Yeah, Josh pointed out that these are fixed in upstream.  I guess we need
to do another snapshot merge ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Aug_2011_15_34_18_+1000_ULqGI3.4e=atEdWr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVzBaAAoJEDMEi1NhKgbsd5sH/iA5hrOlsIb8loz0sHgogijN
wjVXPmFh7XhBZY8oFWAOJeO5hUIf6A/8K+SXDHLw3uTznOr2/PwPBPGMh51nkkfU
ka6juJmv9FxLkE5qgeCUlWE7CVwayhV8kvyUADn2G1+HCwcRVeH1c4UIUEHdjkZ0
sGegYC6HEdbTgLnPOl+niRH76BMGa6OJflNYejhprJn8zZbLf5NSJkViFhXUCo8F
W7gQE5Nr3Sq2OXuFfSk7kprIBUPChoQ8l+qY29mbJsWvs8NMcBL5l3LW0BlGZDoE
ew9gjCGui7agGZhbIcfr4XtJwy1t7rd6xSeUol1KGmLcIggaCZy1J/p9+mMxXBs=
=GVzS
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Aug_2011_15_34_18_+1000_ULqGI3.4e=atEdWr--
