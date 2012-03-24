Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2CXLMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 07:12:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab2CXLMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 07:12:44 -0400
Message-ID: <4F6DAC28.301@nod.at>
Date: Sat, 24 Mar 2012 12:12:40 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Subject: Re: [PATCH 07/10] um: Should hold tasklist_lock while traversing
 processes
References: <20120324102609.GA28356@lizard> <20120324103030.GG29067@lizard>
In-Reply-To: <20120324103030.GG29067@lizard>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE41A5EA7F7A3D882738B89D5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE41A5EA7F7A3D882738B89D5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 24.03.2012 11:30, schrieb Anton Vorontsov:
> Traversing the tasks requires holding tasklist_lock, otherwise it
> is unsafe.
>=20
> p.s. However, I'm not sure that calling os_kill_ptraced_process()
> in the atomic context is correct. It seem to work, but please
> take a closer look.

os_kill_ptraced_process() calls a host function.
=46rom UML's point of view nothing sleeps, so this is fine.

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard


--------------enigE41A5EA7F7A3D882738B89D5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPbawoAAoJEN9758yqZn9enHsH/04wJSPdhgma1hiCpbwhLKzT
jLaxk9Jl2lXj7n7ydXmtkkiYkO9QCi9syUAFKi5fV0HDyI4Yvo9ymPUOxAd569mQ
p8Jo3iUBrgDKMbUAHyK+xxawB0TsLynRQbNY1iaKhbjcR9ejqKddlDXlV40GI3k0
bU/Yk1umtUZhV9sT1ymTiHa/zAzRRhTa/AlOONRsLFWYGwtdYTm2vnDwPR0x18Zg
kNF0OKf1/4hFCNUHYpJ8F99PDMN/T5hyJ52iXUsqeg/eJS5rJopbtsTFUxf1Fh78
ksu1G6Xh5iWQVHQPDWcNrSN7t4oWbpb6OlsdojQYdOEXySuUtBVELMcjhwMCELU=
=bzOH
-----END PGP SIGNATURE-----

--------------enigE41A5EA7F7A3D882738B89D5--
