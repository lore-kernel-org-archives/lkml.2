Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2FMCwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 22:52:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40658 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2FMCwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 22:52:37 -0400
Date: Wed, 13 Jun 2012 12:52:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120613125226.635d819e37ccb29cfcfdbba4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Jun_2012_12_52_26_+1000_sItTLAXS3Gz_FCkv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Jun_2012_12_52_26_+1000_sItTLAXS3Gz_FCkv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

FATAL: modpost: GPL-incompatible module snd-soc-ab8500-codec.ko uses GPL-on=
ly symbol 'snd_soc_put_xr_sx'

Caused by commit 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver").
I think the license string is spelt "GPL" or "GPL v2" not "GPLv2".

I have used the sound-asoc tree from next-20120608 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__13_Jun_2012_12_52_26_+1000_sItTLAXS3Gz_FCkv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP2ABqAAoJEECxmPOUX5FEf20P/0YwUu1oMgpFRzTTGelMHn6f
EwY1qZ+CpqYx2BIwOAMgn1h2QqZv9MritI5aT14jiAGG4qzJLHSgX0Ws0eIL2f+r
qaA040rFCP7gofb2hPWVGGpei6CoBw/NXzzGhRp1I+Ef6T9pYfvKIOm5KY1jItcW
/6TG2cU2vlh52CxtP3+iqPQuXW1lCSmV/j/kbFU0iafKT7RyCAlaBvdBPUXt2tqS
7ZtVmXM6/zyWU9Lsyqk7l7VT5i8SHg8Ebezjld1eCgOo2M8/U68EPbUR8azYsOwe
mZc/NZwQgOH9FoTm8r+OS47Y9Vo/6JhxY8nmmGv4IMZLwmq5lxbZfypwFEPt13Ou
jL0TJ2QM+gSkZaWCiWqU1JSz53bFpp7Z2UXb5/nz3/iCA8bFm8KJCaLW2G5xLaaR
I0wYbjvvRe+w6zI+3FON9S4aGLrbiVxjpD9eJo+26/RF7KKjvIQGhQc+1lUPXX5H
o7ZabMtHxSpFAQXEWoP0x24zrogCyPMwVltzfzkZrqXNZiDio32yLLTiI+BoJEi7
R3mNIS4cmHWwwG6HrvlBiYnRtW8uFzejALepz5q9BSavfihKHYUwEh2xfxUeh/c3
X9pEilL6m5Pc5fSsAtxkb2hlqCKi/E11bq8IxNCbe5NgisESPzEwNYeWfDxK+d64
8H5FVrayHa/YpDH6F9CN
=J25n
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Jun_2012_12_52_26_+1000_sItTLAXS3Gz_FCkv--
