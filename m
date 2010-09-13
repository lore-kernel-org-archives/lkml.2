Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0IMOVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:21:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41187 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab0IMOVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:21:41 -0400
Date: Tue, 14 Sep 2010 00:21:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (maybe
 percpu tree related)
Message-Id: <20100914002132.bf17c19e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_00_21_32_+1000_ESIOqtaAkNXw0hPH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_00_21_32_+1000_ESIOqtaAkNXw0hPH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, next-20100909 and next-20100910 builds (alpha
defconfig) failed like this:

In file included from mm/percpu.c:71:
arch/alpha/include/asm/cacheflush.h: In function 'flush_icache_user_range':
arch/alpha/include/asm/cacheflush.h:53: error: dereferencing pointer to inc=
omplete type
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_00_21_32_+1000_ESIOqtaAkNXw0hPH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMjjNsAAoJEDMEi1NhKgbsvZoH/1RLUgfKE7NGmt7ODzXgtcdN
o9RxjY/OJpzFqfRPCH3XaU8jD0IWWzTZ6AbjJ7Zqv6gNa1ixiqvBJk+jugI1FNA8
6ShRtdTOul4yHSlwpyx8zKEk17p2bBzg9VQRBmQdFqS9BX80o/pFvOeWQhnXAtFf
6RAbL/M6QCyZElvG87V0vh9IIp4Fmj2+hQV9RKfjIG1sctLZdipyrnI9P3WDk50N
jYEf/GPzBpXUqrkkOHWHpKamin+r7aZdWYu4OZQSW0ZZH/dR0t9smZOvB2yNS3bl
4wiMTPwbc03Z2tcD0q79gbuHeCP1ZhRP/VRe58pO3/bnLgZVjVw6WG7/pnhmsQY=
=y2N+
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_00_21_32_+1000_ESIOqtaAkNXw0hPH--
