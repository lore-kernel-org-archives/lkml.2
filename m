Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375Ab1JGDeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:34:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965324Ab1JGDeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:34:20 -0400
Date: Fri, 7 Oct 2011 14:34:12 +1100
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the md tree
Message-ID: <20111007143412.19290057@notabene.brown>
In-Reply-To: <20111007140704.1ba7b29ccf5b8aacdb43560a@canb.auug.org.au>
References: <20111007140704.1ba7b29ccf5b8aacdb43560a@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xqNy1Vhg3oazh/x2gvzuIsf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xqNy1Vhg3oazh/x2gvzuIsf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Oct 2011 14:07:04 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
>=20
> After merging the md tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> In file included from drivers/md/raid1.c:40:0:
> drivers/md/raid1.h:71:2: error: expected ':', ',', ';', '}' or '__attribu=
te__' before 'int'
>=20
> and went downhill from there ...
>=20
> Caused by commit 9d64362373aa ("md/raid1:  add documentation to
> r1_private_data_s data structure").  Please build test ...
>=20
> I have used the md tree from next-20111006 for today.

I've fixed it up now. -- sorry about that.

NeilBrown

--Sig_/xqNy1Vhg3oazh/x2gvzuIsf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTo5zNDnsnt1WYoG5AQIkbw//ctGO+smSUDKG3CP44Yo2VtQtsirNZLDJ
abzly363okJvfp0QkqU3mc9m4/6KsF8SsLuOwUnrJligWJuHR/F9ZvboV6np/gDZ
/tPr+vw64yDTe2ffTwb7KwZA3PtlFJmzcf0qhpMUwvQlpjCPuVL7pYOJAWt4BvUd
kqeaG79G5Z2Mf0xiHAM8Wbd5TcXNW701Cf/lrFNyX+W0pQh55dNPWg/PcOterN9d
/DE/08WOiT5a48ly62NtFg9kNWe+q98l73nj8ECY7QhqW61Vt4aqSFSUqVfCpuqu
ih/nJH3SOfHa+TQXvROCbKPu3QOFhoW9+hKCCfswuVqtIrWtBdYQa96ZZcBCxRtK
iPPooja83dWQ0JDU/efr+eNrKACKMStlL3gGZkdHjgaOdbcr9up/VBokNH0Ggzy2
T1H6C4Xki5Bac6TdfYpJiRNzpcR+jxOhokBmobN7FL8kn72yiwQB0JnjqIDtQ1J7
YhliI3pgWJp9rHUeHq0gQxcSM020hQhFlYTB9xPKtvmp2GN3HX7EH4mt9SeCeu6S
YbdOuItGij/j2Oi+wIMYn8ShB573sN5HzQ+ExeisoOee1sltL69BOUr6e7/mwsxA
FqE4KnnQrJ6HGkikw66O6dE3+J8XHA4xyRfh0fh26DznkptRP8sy2DT2RaRAiLwG
2P93UzDeOG0=
=p1yb
-----END PGP SIGNATURE-----

--Sig_/xqNy1Vhg3oazh/x2gvzuIsf--
