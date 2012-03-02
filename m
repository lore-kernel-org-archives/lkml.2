Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab2CBBMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:12:05 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942Ab2CBBMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:12:03 -0500
Message-ID: <4F501E60.3090701@nod.at>
Date: Fri, 02 Mar 2012 02:12:00 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: OpenRISC: BUG: failure at mm/page_alloc.c:2467/free_pages()!
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAD10C4B40BCF779998401382"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAD10C4B40BCF779998401382
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

CONFIG_DEBUG_VM exposes this splat:
BUG: failure at mm/page_alloc.c:2467/free_pages()!

addr is 0xc100c000, but memory_end is 0x02000000.

Thanks,
//richard


--------------enigAD10C4B40BCF779998401382
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPUB5gAAoJEN9758yqZn9e4EAH/Rnxm8InPqpPyF4ZmV5P1yWq
Xet4sispDVLDKKDOye93qSO4GVtu0IeZzDx7SNu3uCk8C7c9m7cTUKbkbyluY79J
/YQv9y2neLwuGGY5sWYbeTz7jzfmxeZZ64YMZrn0Kh4rpPRNbQCZk3UegrSLETDh
TQ3Ug6WrcAmLwQ/bd1rAmQem7ROWst8eXaR+2K/cZPp0lnd2nxKGkjObeU7ycuA1
Cw5p0d8E2HwoGmi9yo1+GqidPyDsQcKmytqGhiVWpQ0mC8xTbznufK/o4ZPEJBYL
umGeYP70vWrWrdQ1VYEReGv688IP3qloE1IkNSLNE7nN4n6eGSJhumxX15/QCd4=
=M5uW
-----END PGP SIGNATURE-----

--------------enigAD10C4B40BCF779998401382--
