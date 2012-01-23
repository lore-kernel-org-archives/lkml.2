Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2AWNLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:11:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37412 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab2AWNLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:11:02 -0500
Date: Tue, 24 Jan 2012 00:10:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120124001043.d2e874ed0a10260485c3ff74@canb.auug.org.au>
In-Reply-To: <20120123104722.GA9681@sirena.org.uk>
References: <20120123121422.f3e41d97bae580544abfab63@canb.auug.org.au>
	<20120123104722.GA9681@sirena.org.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Jan_2012_00_10_43_+1100_9f6wTEfIfVFfc16q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jan_2012_00_10_43_+1100_9f6wTEfIfVFfc16q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, 23 Jan 2012 10:47:22 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Mon, Jan 23, 2012 at 12:14:22PM +1100, Stephen Rothwell wrote:
>=20
> > Caused by commit 899896379670 ("ASoC: sgtl5000: Convert to table based
> > DAPM and control init").  Please at least build this stuff :-(
>=20
> Mainline doesn't build (and wouldn't usefully run) for any of my
> interesting configs right now which does tend to push testing of -next
> down the priority list.  Hopefully the fixes will make it into mainline
> at some point soon.

The above remark was aimed past you at the developer involved (who has
already responded).  People should not be feeding you untested patches.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__24_Jan_2012_00_10_43_+1100_9f6wTEfIfVFfc16q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHVxTAAoJEECxmPOUX5FEVmYQAJIHcQyboonO2vQXjkXZpXeP
kBI0qBelabkoZH6uhG6z5eyk8X/drUj13JJ1L8F9vA/Yur2i7+agNa3QJ1EadKXJ
5Bw6XOIKfEhGXn/SdsmzJFBotyyQKeh+PzCebw8uVo41JJUDKQFRlqk+khG+A8OS
oc7b47s6Cwtua19FZ2a3uQpSTAgkEtBUFjBua0aCR1XhyMD5s6UfoN0gHJ/A2AoW
Sd7rTJrAL1IAfshMtA/ZffjKd6AcrzpNsH3zDLWN3FTs4FhnnlWgqKN7xhFcf1Cr
zHx2RGaiE9fuOTWjAMPjuQscGUkbn0P7qG0SrLYoa1qGzewCqRqoXyQ5CH3VOhyh
Ro3ovx95wMVYPgaI8ocI9hx/Av3yig+q4tQo0400yC19KlVkF0Rdc6VSJd3j1O1w
netROI09cCC9spgYCiX/q3tneXXkRi0/9ZvVrr02TH1K8LHB8zzFwIkQ0TjnyLM5
UJetg8lzrUS8gH5XwnhYh+nuNdjjxcEhMtfq9MCmIsIhweuqtjnRj03uretH45EY
qfnmsHx4SZ1yvx6zd9E/K7tPZViCX83YPgxF8tkhHX2rnK5XzjFucqwiBDLsdv/X
00GBcqn27CUjLy1PDuRL5EAKKhpQjOCZm9zSmbka/iMPwHb7e3MA/fXyVEo9UhWj
zSkltNni1gLYHffNk76p
=wdkU
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jan_2012_00_10_43_+1100_9f6wTEfIfVFfc16q--
