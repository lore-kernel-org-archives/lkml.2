Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2CXLMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 07:12:33 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab2CXLMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 07:12:30 -0400
Message-ID: <4F6DAC15.7040702@nod.at>
Date: Sat, 24 Mar 2012 12:12:21 +0100
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
Subject: Re: [PATCH 09/10] um: Properly check all process' threads for a live
 mm
References: <20120324102609.GA28356@lizard> <20120324103110.GI29067@lizard>
In-Reply-To: <20120324103110.GI29067@lizard>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig88EC09FADEB6B6709009C1CF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig88EC09FADEB6B6709009C1CF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 24.03.2012 11:31, schrieb Anton Vorontsov:
> kill_off_processes() might miss a valid process, this is because
> checking for process->mm is not enough. Process' main thread may
> exit or detach its mm via use_mm(), but other threads may still
> have a valid mm.
>=20
> To catch this we use find_lock_task_mm(), which walks up all
> threads and returns an appropriate task (with task lock held).
>=20
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard


--------------enig88EC09FADEB6B6709009C1CF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPbawWAAoJEN9758yqZn9e/icH/iVN9aQ0/yXa9SJlm4SLtuzl
ihg243HbKaJpRbPXf+fqsEVutMgRKM+yqkVmeuTdeADDdVSoyoBb750N1fPvq7pU
yjTzeNfWySr727F6cMgblhtKzilRd6JOq+lI3JD74T/pga6mrlIE8Os8fp6HOyfR
sIyklQPPtXml4b1CboiWWwc8qlHSX+2I5w2pCcOSUozsFa8rPBdvtxiXVES0OdJJ
ZFcw2OICs2DbRRJXrq1PCx/qU6e9b3kb5Mj/peSQosjIltksQNafKECm6tonM8TN
e4ZxUnOXUxaULn9E5C7YnuQdP/0SnmF5jnKYNkNqwNIh+oqDPoVgmKnv7aG49GQ=
=Ic2C
-----END PGP SIGNATURE-----

--------------enig88EC09FADEB6B6709009C1CF--
