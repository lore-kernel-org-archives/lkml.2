Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1GRPYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:24:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48046 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1GRPYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:24:39 -0400
Date: Mon, 18 Jul 2011 11:24:34 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Anton Blanchard <anton@samba.org>
Cc: Mel Gorman <mel@csn.ul.ie>, dwg@au1.ibm.com, akpm@linux-foundation.org,
        hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hugepage: Protect region tracking lists with its own
 spinlock
Message-ID: <20110718152434.GA3890@mgebm.net>
References: <20110125143226.37532ea2@kryten>
 <20110125143414.1dbb150c@kryten>
 <20110126092428.GR18984@csn.ul.ie>
 <20110715160650.48d61245@kryten>
 <20110715160852.0d16318a@kryten>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20110715160852.0d16318a@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Jul 2011, Anton Blanchard wrote:

>=20
> In preparation for creating a hash of spinlocks to replace the global
> hugetlb_instantiation_mutex, protect the region tracking code with
> its own spinlock.
>=20
> Signed-off-by: Anton Blanchard <anton@samba.org>=20

These work on x86_64 as well with the same test method as described by Anto=
n.

Tested-by: Eric B Munson <emunson@mgebm.net>

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJFAyAAoJEH65iIruGRnNl40IAIESxMzphGy3lxxzxvre5DIg
liqsAotlTHNgpUDZKzgH6LGm4ADtL1bDvqMNG+VwD91OO+8tT5oxErJSeeFMaMWi
4rBEvykOp2G5LlObmhQY7fl4S9wEIeIoMh0joC+KLlr53TrlkRsfLoLMstZXNEJ1
Af7mL63KrpxTpvl/rrChlVJEaWAv2Nt2Cr3LLflyeLLDPmh8U27IAOhpce8fhu0Y
q4xlKidPw9ayPUn4vgIYTF7PzFsNqKGtqPkrmXhCI7nvsJcstu6SIFKTaN0c1TL7
T+seYzKtpHCi1q01WbtxAXVTfQYyprTvmSxJXSyTShlDIJV3czjxQ5/rDGS1uOw=
=tgA4
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
