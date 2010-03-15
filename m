Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937000Ab0COWeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:34:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35986 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936990Ab0COWeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:34:03 -0400
Date: Tue, 16 Mar 2010 09:33:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "\\ \" H . Peter Anvin \\ \"" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Next <linux-next@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2] perf: Fix unexported generic
 perf_arch_fetch_caller_regs
Message-Id: <20100316093355.071fde51.sfr@canb.auug.org.au>
In-Reply-To: <1268691442-8300-1-git-send-regression-fweisbec@gmail.com>
References: <1268686806-7286-1-git-send-regression-fweisbec@gmail.com>
	<1268691442-8300-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Mar_2010_09_33_55_+1100_p7_wCx_WonIxv6Np"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Mar_2010_09_33_55_+1100_p7_wCx_WonIxv6Np
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Mon, 15 Mar 2010 23:17:22 +0100 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> perf_arch_fetch_caller_regs() is exported for the overriden x86
> version, but not for the generic weak version.
> As a general rule, weak functions should have their symbol exported
                                          ^
"not"

> in the same file they are defined.
>=20
> So let's export it on trace_event_perf.c as it is used by trace
> events only.

Otherwise, looks good (though I haven't tested it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Mar_2010_09_33_55_+1100_p7_wCx_WonIxv6Np
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuetdMACgkQjjKRsyhoI8w7VgCglSfwgZB2ZWCVgNinzl987ayI
tcYAniWINO7SIJquimGQPhYXvVkOtr2q
=kKv0
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Mar_2010_09_33_55_+1100_p7_wCx_WonIxv6Np--
