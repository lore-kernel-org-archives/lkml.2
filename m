Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1CNJC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:02:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41738 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab1CNJC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:02:56 -0400
Date: Mon, 14 Mar 2011 20:02:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the slab tree
Message-Id: <20110314200247.92ae2bd7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Mar_2011_20_02_47_+1100_Gxy_v39ui041lTFb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Mar_2011_20_02_47_+1100_Gxy_v39ui041lTFb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the slab tree, today's linux-next build (powerpc
allnoconfig) produced this warning:

mm/slub.c: In function 'slab_free':
mm/slub.c:2124: warning: label 'redo' defined but not used

Introduced by commit 8a5ec0ba42c4 ("Lockless (and preemptless) fastpaths
for slub").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Mar_2011_20_02_47_+1100_Gxy_v39ui041lTFb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNfdm3AAoJEDMEi1NhKgbsv0EIAJkuAS5RqE4xnNeMiZ4juE49
I/CDMconVUVhLHcs3WUkRNIqq9LlTrZVGPH7oxvPmp9Cqg//Ow1fTTLweKeTYYJn
fwNYlufgEipEBgTvU5rht8G2vpFxyd3u1bVGbClcCT2WrUGHcRur0Ic0rPmCMlEf
HcDuxHh9k+HN6wTuC57qMQClsMld4+g5eESNxLpQDcGMxHLZ0toCwz2k7VCPsZO8
bvO6e01EUy5MZ+jiEQTVmRa7KZt2/bsmYT7FJSKXLz7pBv1rZ5kfO1lAX8+WYrhS
3th1l2XzTowMr9SH7Uu90L+rKsKXGuLK1ROuJhLF13HDDyZSZBw4uA913tUzULw=
=s9L/
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Mar_2011_20_02_47_+1100_Gxy_v39ui041lTFb--
