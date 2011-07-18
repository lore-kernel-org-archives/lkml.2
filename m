Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1GRJbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:31:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60742 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1GRJbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:31:06 -0400
Date: Mon, 18 Jul 2011 19:30:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110718193053.623d28dc4643ab488b6347d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jul_2011_19_30_53_+1000_HE_.qhnIhBqHI=P1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jul_2011_19_30_53_+1000_HE_.qhnIhBqHI=P1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

In file included from arch/sparc/include/asm/pgtable.h:4:0,
                 from include/linux/mm.h:41,
                 from include/linux/fs.h:395,
                 from include/linux/compat.h:15,
                 from arch/sparc/include/asm/siginfo.h:19,
                 from include/linux/signal.h:5,
                 from include/linux/sched.h:73,
                 from arch/sparc/kernel/asm-offsets.c:13:
arch/sparc/include/asm/pgtable_64.h: In function '__set_pte_at':
arch/sparc/include/asm/pgtable_64.h:674:6: error: 'init_mm' undeclared (fir=
st use in this function)

I assume some include file changes.  Anyone have any clues how to find
this?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jul_2011_19_30_53_+1000_HE_.qhnIhBqHI=P1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOI/1NAAoJEDMEi1NhKgbsl+AH/36zoa+KgbLCI8dLAOG+rJdj
kbn86Bj/uLBrtqMDB6sqU94CpGCfnUJ6OqYOOXlrsi0YNa0PK9kqIDMP7whxGF4o
jMbNDZlq+KyzDK2G/keFAxoPu5zXATWIDOLGJGoLpm2SMw+H7SsH0KFuLw+zpynR
x8OhH3boiUPdEL8WyOu231RtbOElpBkAedLIplctSrVVkOi1VdwwTqiLyOoenD8z
KcgHA4eSLH80Klmp2adLj6z6p1kzL4k2gWqMyiYjjqSnqfFVDTJOxWPADqFcsoO+
r58T6vs8Ftpy4AyBhbJi5O9ZchRIgQMeAqDmOVXM1Lel8wg8j3W/NuCZ+mzUfW8=
=Ayfv
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jul_2011_19_30_53_+1000_HE_.qhnIhBqHI=P1--
