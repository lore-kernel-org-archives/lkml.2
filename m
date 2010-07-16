Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab0GPXIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 19:08:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37477 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431Ab0GPXIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 19:08:09 -0400
Date: Sat, 17 Jul 2010 09:07:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20100717090756.ccc2cae3.sfr@canb.auug.org.au>
In-Reply-To: <20100716205812.GA14297@flint.arm.linux.org.uk>
References: <20100716171124.064cf319.sfr@canb.auug.org.au>
	<4C40A766.6060309@kernel.org>
	<20100716205812.GA14297@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__17_Jul_2010_09_07_56_+1000_AGkTAmxPl2ZfR=Hs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Jul_2010_09_07_56_+1000_AGkTAmxPl2ZfR=Hs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Fri, 16 Jul 2010 21:58:13 +0100 Russell King <rmk@arm.linux.org.uk> wrot=
e:
>
> On Fri, Jul 16, 2010 at 11:39:34AM -0700, Yinghai Lu wrote:
> > On 07/16/2010 12:11 AM, Stephen Rothwell wrote:
> > > Hi Russell,
> > >=20
> > > After merging the final tree, today's linux-next build (most, if not =
all
> > > arm configs) failed (not unexpectedly) due to the lmb -> memblock ren=
ame
> > > (commit 95f72d1ed41a66f1c1c29c24d479de81a0bea36f "lmb: rename to
> > > memblock").
> > >=20
> > > See http://kisskb.ellerman.id.au/kisskb/branch/9/
> >=20
> > You or Russell may need to run the scripts in that patch
>=20
> I've already fixed it up.  I'm guessing that we'll see the results
> sometime on Monday.

I figured that you would have.  And, yes, I will pick it up in Monday.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Jul_2010_09_07_56_+1000_AGkTAmxPl2ZfR=Hs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMQOZMAAoJEDMEi1NhKgbsKTgH/0Tb3jCkP4pDj0MWUnITQXTq
tmxJU0Eyxpgw5+kdHJOAKuQZeiBNKPuWJaJwnLCfLyI3vBkGUodU2UcXBhVc2zkp
YlTt3Ld+rQSsg2+H/kX8PzUGJMPJO1JbiwgLcBVp6gQCGZEACVIUJjplY1AetR/W
bjgnvnR6cyazDkueMONCT5EiEarZpxcasXMlFbjl7GvWaLnhz3vjRwTaq+wUc84I
gemWTaeuWycTIzd8jhICJ4Vd0epWLDTKU/JwDF9Kzf2TE/xwmKP96NpAOkJzQAYR
Y7az5hVO5UVRM5Z9IeGN8fU9Qpi7ZhDNRPw0v3R7NjXvhBEe8gg8RDxlrFBPS/k=
=4vnQ
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Jul_2010_09_07_56_+1000_AGkTAmxPl2ZfR=Hs--
