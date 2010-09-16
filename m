Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab0IPEY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 00:24:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33432 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0IPEY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 00:24:27 -0400
Date: Thu, 16 Sep 2010 14:24:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the irqflags tree with the sh tree
Message-Id: <20100916142420.f2b31afa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_14_24_20_+1000_Z=pe.fJ8g3YFC8/S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_14_24_20_+1000_Z=pe.fJ8g3YFC8/S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the irqflags tree got a conflict in
arch/sh/include/asm/syscalls_32.h between commit
b9afa3e015273a52718e0a7efe198a0df76be880 ("Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6") from
the sh tree and commit 88c215b32d8af27367dd105f1cf90fa8164b4d3b ("SH: Add
missing consts to sys_execve() declaration") from the irqflags tree.

Same change, but with different white space.  I used the version from the
sh tree.

So, David, you could just drop this patch.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_14_24_20_+1000_Z=pe.fJ8g3YFC8/S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkZv0AAoJEDMEi1NhKgbsm6MH/A5tgvUZpm1BNtX4K+R5ahta
oAjdZ66ggqWFeFR9FsD3nGbZT62aNLFLy4MLdROlRsShfmYWvchCLb3BwZ0BkQFO
KbGv40du8RMG6xy4bwroBqWOecquNAN1/j/SwIj77qGJstEWQW16yBeP9GdGO7SI
lS4E+nTdZOVa7LoPNIHl6ODMUeS7KtYfnpwqh+nemz4kooEbcpA52NDoe5F9ELmS
ot0BTR0abkonIpNabOYiwnLXaXVoeSBQMyusSoUD9BFHpMr/PyFvmN1eW5H6KCtx
z9M1WZsq15VE1aVEbmkgAeEWk57Tg8Hbl0eAaaddqtnhOK57iwMMYxMpcsnikD8=
=JBDD
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_14_24_20_+1000_Z=pe.fJ8g3YFC8/S--
