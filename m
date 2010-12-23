Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0LWAxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:53:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57281 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab0LWAxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:53:48 -0500
Date: Thu, 23 Dec 2010 11:53:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jassi Brar <jassi.brar@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the sound tree with the s5p tree
Message-Id: <20101223115339.1ce18216.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Dec_2010_11_53_39_+1100_PDcxb8+.dBd15KbN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Dec_2010_11_53_39_+1100_PDcxb8+.dBd15KbN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
sound/soc/samsung/smdk_wm8580.c sound/soc/samsung/smdk_wm9713.c between
commit 7ca825bed699c77b218ead402202df384556950b ("ASoC: Samsung: Rename
DMA device") from the s5p tree and various commits from the sound tree.

I used the versions from the sound tree that seemed to be supersets of the
ones from the s5p tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Dec_2010_11_53_39_+1100_PDcxb8+.dBd15KbN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNEp2TAAoJEDMEi1NhKgbs3yIIAJ/UbAxeZV9rHDtY3KKIslTV
x9FyE6Kg0D9kKTBsPG5W50/FfQoF1ny8dk1WLoqyOlvlhdcZa4InsKsC1wuQcTFs
xKUBI0w1oCkcKJb8klBZvl5/Y9f/8Fl5H/kTdc3scc/b/yTWFjUT4H88gna88VPs
UfQVs0PDKV3qP/NOwpdqXdubnm9xBewEf9pXTthPvtwRdvQ58LYOC3CiiOMDkvgw
WBdiSuLhn6ZxvxScsLKwI3PiqJFy8wbbv9PJK9N3VlbHGV/Iv+mB+FOGBaeqdnZJ
b9/aVB+Pceg/en54iDyEj0Vufe33Rk7xG/O/YRfNi2hQ+alzbeF3Te8LGaFA8fg=
=2R4e
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Dec_2010_11_53_39_+1100_PDcxb8+.dBd15KbN--
