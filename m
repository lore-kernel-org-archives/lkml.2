Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2EMATp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 20:19:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44953 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2EMATn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 20:19:43 -0400
Date: Sun, 13 May 2012 10:19:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add myself as the cpufreq maintainer
Message-Id: <20120513101931.39617e4909fcc10d6739bc75@canb.auug.org.au>
In-Reply-To: <201205112135.46097.rjw@sisk.pl>
References: <20120504160417.GA421@redhat.com>
	<201205112116.25257.rjw@sisk.pl>
	<20120511192420.GA10041@redhat.com>
	<201205112135.46097.rjw@sisk.pl>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__13_May_2012_10_19_31_+1000_2AiNKWVvWj.PxLel"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__13_May_2012_10_19_31_+1000_2AiNKWVvWj.PxLel
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,  Dave,

On Fri, 11 May 2012 21:35:45 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> Since cpufreq has no official maintainer at the moment, I'm willing
> to maintain it along some other power management core code I've been
> maintaining already.

I have cpufreq-current and cpufreq trees in linux-next (both currently
empty and with Dave as contact).  What should I do with them?

cpufreq-current	git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq=
.git#fixes
cpufreq		git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git#ne=
xt

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__13_May_2012_10_19_31_+1000_2AiNKWVvWj.PxLel
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPrv4TAAoJEECxmPOUX5FEbfcP/39UlN8diBfot+JDX9E1BpRg
eDGi60JQru/RE+5HzED8BmP+sWKrTqP5fLapnGdntsdmOz0+1YGphBdk1Eypt3RC
EatxAuhNE/dR4T71PuARn8vDkyIdMIDifdF6+Uaa/95tkBvaYE6AJszzYMllAemT
N8LAqoR/uSWXaG7gTyS+1sfOKHpyJi6zabcx0WZxq+Vh11lVxe1F06X5x2HJbVvE
HHRcWV4oUnuFtc++dBNC5bqQSapSe/M76QK8m9cnSM7TLgGpMGOnpDUZ7aruelJx
brad0Lpb7uK/b2G1MeN1+VLmNm3TTjthdf0J8YD9JQQFE8nnaXdy+0eW+XNNvrJg
gStBR2wWz9EVVfIIj9T5DQOyzrGTiGoSPrKEjlF0oTCsQigFjrvpyoMcsThhCiy5
1tMzxVlAYj4gBiHH/Moc0HhqcaW8Bl9jY1a8ztfaujlbtEZBzCh6jJpOHbny+ve1
vD/4FGrU4uU6kgFC3wxQ4sfob43CdXeNJxuEaCT53i7bnH2WyhqHJ9Jpq7G0Vos9
lhFZK5x75+7BKrz/Dpmofpoo5FojuhEvv9vdKaSyShqVuLMHIbiLbt/B2NEsN+5W
ISrExGbxKYbVMwiVmMb9HDQRtfpXSFC33M+lGuB/owAL9looFOYU+E5HlutXlCI8
HxFSY8tubV9OEpDuc7jv
=56ga
-----END PGP SIGNATURE-----

--Signature=_Sun__13_May_2012_10_19_31_+1000_2AiNKWVvWj.PxLel--
