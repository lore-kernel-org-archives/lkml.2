Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab0DSHfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 03:35:32 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:45158 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab0DSHfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 03:35:31 -0400
Message-ID: <4BCC07C0.5050601@web.de>
Date: Mon, 19 Apr 2010 09:35:28 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] uml: Fix build breakage after slab.h changes
References: <4BCB353A.3040806@web.de> <4BCB788E.2040501@kernel.org>
In-Reply-To: <4BCB788E.2040501@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigECEAA47507809F97268BA43A"
X-Provags-ID: V01U2FsdGVkX19i9uoOtJR8j7GyrL/s5hll1po/+pOovmRNGWFg
	FjkXYkD0wkvf2CBbK7LSRwbQrBYnWpPgrFnJk/7yas1bmN7kai
	wRmKO6HBM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigECEAA47507809F97268BA43A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Tejun Heo wrote:
> Hello,
>=20
> On 04/19/2010 01:37 AM, Jan Kiszka wrote:
>> We now have to to include linux/slab.h explicitly for kmalloc & friend=
s.
>> Files that build against host headers already get their prototypes via=

>> um_malloc.h, linux/slab.h may even be unavailable.
>=20
> Hmmm... my test um build was okay but I don't know much about details
> of um builds.=20

We may use different configs. Also, your userland includes have to lack
slab.h.

> I suppose this patch will go through um tree?

Good question. Does such a tree exist? I'm sitting on a few more um
cleanups & fixes, and so far I'm working against Linus' tree as I failed
to find anything more recent.

Jan


--------------enigECEAA47507809F97268BA43A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkvMB8AACgkQitSsb3rl5xSVZgCfVGI6pJXVFibUZ6Gbuy1Ue1BY
VK0An00HqFcHT7Bv2Oi7vp8v1ceZtr1s
=LFFY
-----END PGP SIGNATURE-----

--------------enigECEAA47507809F97268BA43A--
