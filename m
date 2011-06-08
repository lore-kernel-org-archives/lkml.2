Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab1FHAbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:31:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37164 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab1FHAba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:31:30 -0400
Date: Wed, 8 Jun 2011 10:31:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Subject: Re: l2-mtd-2.6.git to linux-next
Message-Id: <20110608103122.5b7b54d0.sfr@canb.auug.org.au>
In-Reply-To: <1307345850.3135.24.camel@localhost>
References: <1307345850.3135.24.camel@localhost>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jun_2011_10_31_22_+1000_cR9EG/VMwclvv8v0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jun_2011_10_31_22_+1000_cR9EG/VMwclvv8v0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Mon, 06 Jun 2011 10:37:30 +0300 Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
>
> as we've discussed, please, include l2-mtd-2.6.git tree to linux-next:
>=20
> git://git.infradead.org/users/dedekind/l2-mtd-2.6.git master

I have added this today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__8_Jun_2011_10_31_22_+1000_cR9EG/VMwclvv8v0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7sLaAAoJEDMEi1NhKgbso7oIAIcBvWYNm8mVy86kgaCGysK9
4X+FmkVMcWFCPwfYdsylCkloMJbfPIRJdNOowEP5ZBV7gFIB8m3yOFY1hy8KXetn
8ykltLKTN2cOpFD6GDxTBlOe5jRu2s+5ZkphS2VLDYUXUZCkCiXg0oJLsGq2SZA6
d61w/KWD+S6AvpCEU13/J0nwcqCtXZKyN/OquyfDtgkCpQyi77IW2uK67VChh1FP
+3c7DmjSWW832giFJhx4vD3lEzVfl8tfB3NNX2SvTgX4O+AX0WFzgtmUVX36P5IG
U7F6dFYmN+m8aCtYx8gN3Mu2Jl0XQMHPfURl6B3VHc83M5R9uDZuwpgNkwHVIR8=
=Huzf
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jun_2011_10_31_22_+1000_cR9EG/VMwclvv8v0--
