Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1HYEZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:25:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55339 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab1HYEZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:25:02 -0400
Date: Thu, 25 Aug 2011 14:24:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the xen tree with the tip tree
Message-Id: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Aug_2011_14_24_50_+1000_t.+JNcCB6lCv/EwC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Aug_2011_14_24_50_+1000_t.+JNcCB6lCv/EwC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen tree got a conflict in
arch/x86/include/asm/spinlock.h between a series of commits  from the tip
tree and a smaller series of similar commits from the xen tree.

I see that Linus is commenting on these patches at the moment, and its
not easy to resolve the conflicts, so I will just use the xen tree from
next-20110824 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Aug_2011_14_24_50_+1000_t.+JNcCB6lCv/EwC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVc6SAAoJEDMEi1NhKgbsy5YH/3gEQdnIgSjftQf1OnQ7bejz
kHHthImNfmlIdRirF8BuZEb9rZxl7Fv8O+36IQwLjKcgte1XOCCI9UmMAWDX8oZh
fqrOe19z9ipxCxw3QDooI7kyQJZTP2dUlqjz0sJNywobrzXUWXHucXQ/9OUPfrf8
/RPrdKWEeq1kRtSaR1yRxuhgyf1YqSC05lSfRii9+eGqKe3LT7EF3/gjumyIgtSM
hb0o6tYxOwN4DgZ+wKiJGLcdSS5dMrxPk+G3Uu6W030ObOMXfgOYhNau7ffD2kzk
E3ZIFX5EHnAnDw6HOtBTN4E7dBoonV2gyfqrU2i5YZQOPz3oSxDQh+3HaVzcGfo=
=qdeA
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Aug_2011_14_24_50_+1000_t.+JNcCB6lCv/EwC--
