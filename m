Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985Ab0G0EOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:14:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38870 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0G0EOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:14:22 -0400
Date: Tue, 27 Jul 2010 14:14:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>
Subject: linux-next: manual merge of the tip tree with the cpufreq tree
Message-Id: <20100727141413.2c67e158.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Jul_2010_14_14_13_+1000_=f_lfSfh_ROnWiMB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Jul_2010_14_14_13_+1000_=f_lfSfh_ROnWiMB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/cpufreq/cpufreq.c between commit
1f247ccc157ce29b4cd1e1b9cbe3cce8f24522bf ("[CPUFREQ] x86 cpufreq: Make
trace_power_frequency cpufreq driver independent") from the cpufreq tree
and commit 4c21adf26f8fcf86a755b9b9f55c2e9fd241e1fb ("x86 cpufreq, perf:
Make trace_power_frequency cpufreq driver independent") from the tip tree.

Slightly different versions of the same patch.  I used the cpufreq tree
version of this file (it has an added dprintk() and fixed whitespace).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Jul_2010_14_14_13_+1000_=f_lfSfh_ROnWiMB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTl0VAAoJEDMEi1NhKgbs77MH/32C6JGurmiP6D0E+bVhpETM
IeTNgc7bzXzOtvvBwhdYfRqzbdhtZfBSEZdOWv0Ev78vNEBTjSAXSQWTunVuzfNB
ybm3CA4oNTesWOvulA2CDNTh9F4zHzKl7A4oKmHZl3cRVrYNotoZWuIG9sQB5/US
l4VplQe5KP1RzhYp2hUuUumVUCwhblkfbuvtfB5jw66DqvX2ebwdV4EsU/dA+gYF
WBQZLKAA5zqON01ILp8Qf8FYiCIYSq3H0r23IRtdNCA8C7zGO1+hMarqA5PDMcGM
sXftbwIrOVUAZ7QV8hAkT2MiRx7/W19JtzmFLd6TCv6vZ9A85JJ3fWzS+avIhjM=
=sBKC
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Jul_2010_14_14_13_+1000_=f_lfSfh_ROnWiMB--
