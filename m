Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0DTRME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:12:04 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:44451 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab0DTRMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:12:01 -0400
Message-ID: <4BCDE05D.7050701@web.de>
Date: Tue, 20 Apr 2010 19:11:57 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Jiri Kosina <jkosina@suse.cz>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] uml: Fix build breakage after slab.h changes
References: <4BCB353A.3040806@web.de> <4BCB788E.2040501@kernel.org> <4BCC07C0.5050601@web.de> <alpine.LRH.2.00.1004191829220.28179@twin.jikos.cz> <4BCCB89C.50201@web.de> <alpine.LNX.2.00.1004192211140.7579@pobox.suse.cz> <20100420143144.GC30011@c-98-229-117-200.hsd1.ma.comcast.net>
In-Reply-To: <20100420143144.GC30011@c-98-229-117-200.hsd1.ma.comcast.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFB3675D11F4BAC2146C81F34"
X-Provags-ID: V01U2FsdGVkX18cmHLGF7rQGunCOKBJbNCCW+IDo1XS8IBySXWu
	ghf4xCIwEGcPHmu1s7pQV16maDYMDus3qfPj6VxkNqBQ6TkvKg
	IWfoeDMSM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFB3675D11F4BAC2146C81F34
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jeff Dike wrote:
> On Mon, Apr 19, 2010 at 10:12:04PM +0200, Jiri Kosina wrote:
>> Well, if Jeff isn't actively maintaining UML any more, either you can =
take=20
>> over the maintainership yourself, or feed the non-trivial patches thro=
ugh=20
>> Andrew Morton.
>=20
> Yes, these generally go through Andrew.

OK, thanks. Just need to finish my IRQ handlers review / IRQF_DISABLED
cleanups, then I will roll it out.

Jan

PS: If you have any comments regarding the pthread topic, please let me
know.


--------------enigFB3675D11F4BAC2146C81F34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkvN4F0ACgkQitSsb3rl5xSDTgCgoZz46fCcnuMdiT/lBmps3Ea0
D3MAn3xgCy5VR37vyfm1hje1BkWwbcDr
=zTyl
-----END PGP SIGNATURE-----

--------------enigFB3675D11F4BAC2146C81F34--
