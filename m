Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab0DSUKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:10:24 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:55746 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0DSUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:10:22 -0400
Message-ID: <4BCCB89C.50201@web.de>
Date: Mon, 19 Apr 2010 22:10:04 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Tejun Heo <tj@kernel.org>, Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] uml: Fix build breakage after slab.h changes
References: <4BCB353A.3040806@web.de> <4BCB788E.2040501@kernel.org> <4BCC07C0.5050601@web.de> <alpine.LRH.2.00.1004191829220.28179@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1004191829220.28179@twin.jikos.cz>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3640B990EB6D183C933C45CC"
X-Provags-ID: V01U2FsdGVkX1/33ORZS3W10pShEZpAvkNAMwh0lIZqd/oDlew/
	x/ATmR1+X0j17l6UO3uso8PP4YwwYS7ytGBPIav2D+Y6LstA94
	26wklp4kI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3640B990EB6D183C933C45CC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jiri Kosina wrote:
> On Mon, 19 Apr 2010, Jan Kiszka wrote:
>=20
>>> I suppose this patch will go through um tree?
>> Good question. Does such a tree exist? I'm sitting on a few more um
>> cleanups & fixes, and so far I'm working against Linus' tree as I fail=
ed
>> to find anything more recent.
>=20
> If these are simple-enough cleanups and/or compile fixes, feel free to =

> send them to trivial@kernel.org.
>=20

Some are trivial, but most aren't. Will check if I can split the formers
out, but I guess it's simpler to keep the queue.

Thanks,
Jan


--------------enig3640B990EB6D183C933C45CC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkvMuJwACgkQitSsb3rl5xTajQCffeqqvI2VVy7tWiANpP9xlRhY
qYMAoJ6DnahHr/Y0EFjb4dUATx0ZSrAs
=OPAM
-----END PGP SIGNATURE-----

--------------enig3640B990EB6D183C933C45CC--
