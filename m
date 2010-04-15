Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0DOEgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:36:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46747 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0DOEgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:36:16 -0400
Date: Thu, 15 Apr 2010 14:36:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: linux-next: build warning after merge of the final tree (tip tree
 related)
Message-Id: <20100415143609.834da268.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Apr_2010_14_36_09_+1000_kVx26ZCH5DMGGj1+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Apr_2010_14_36_09_+1000_kVx26ZCH5DMGGj1+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) produced this warning:

kernel/sched.c:1875: warning: 'update_avg' defined but not used

Introduced by commit e12f31d3e5d36328c7fbd0fce40a95e70b59152c ("sched:
Remove avg_overlap") which left the only call to this function protected
by CONFIG_SMP.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Apr_2010_14_36_09_+1000_kVx26ZCH5DMGGj1+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvGl7kACgkQjjKRsyhoI8wplQCeN1zEGrVE+dcBJ0/v2CqT2EnJ
oX0AnA5NbEW6RNevalPDqP98kFu3uGd4
=i5sx
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Apr_2010_14_36_09_+1000_kVx26ZCH5DMGGj1+--
