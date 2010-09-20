Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0ITDK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 23:10:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55770 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0ITDKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 23:10:19 -0400
Date: Mon, 20 Sep 2010 13:10:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the viafb tree
Message-Id: <20100920131014.8393b0e2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Sep_2010_13_10_14_+1000_sOMvTjl7IC3UZ+R8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Sep_2010_13_10_14_+1000_sOMvTjl7IC3UZ+R8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

After merging the viafb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/video/via/viafbdev.c: In function 'viafb_init_proc':
drivers/video/via/viafbdev.c:1605: error: incompatible type for argument 3 =
of 'proc_create'

Caused by commit 84e3266c11318f2240e7de7868a14aa1119c613c ("viafb: add
interface for output device configuration") which missed one conversion
of "*viabf_entry" -> "viafb_entry".

I have used the version of the viafb tree from next-20100917 for today.

Also several commits in this tree have the "subject" line repeated in the
commit message.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Sep_2010_13_10_14_+1000_sOMvTjl7IC3UZ+R8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMltCWAAoJEDMEi1NhKgbsuHIIAIngLKS6u5ZJEnECvZW8dtTc
2YCV1WASTDT9m4wbyfZcms6FyecVC+NRuAg7zYshDB5ll/Ih1U80BgLjxEgkXARU
UyZfi0mBCNJJzADhonKrb/x3kQFKHadJUXWcjXQC66OHY0Cl4B6hk7j4vqMCfRRq
17hn9vSSw768RbFM9GSXiMf3en4Hx39Z4BNIyH89grYgehPp9fhR8hsWL8Wyw3kX
Oqnuqa20khNZUO98nq8tYhOS64LAQlSCwinWAagGRh/7BIXjZZBLdgZvXXFdwWls
UJt8OjSo1i2TebSOBwVy8w83JuAJgbdfcGp8zMa9nPJpwS+Q6GA7XopF4z3ydlM=
=kFEM
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Sep_2010_13_10_14_+1000_sOMvTjl7IC3UZ+R8--
