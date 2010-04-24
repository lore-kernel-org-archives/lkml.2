Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0DXMFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 08:05:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41081 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0DXMFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 08:05:15 -0400
Date: Sat, 24 Apr 2010 22:05:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next tree addition request
Message-Id: <20100424220507.b515d095.sfr@canb.auug.org.au>
In-Reply-To: <20100420142716.32c27ed0@bike.lwn.net>
References: <20100420142716.32c27ed0@bike.lwn.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__24_Apr_2010_22_05_07_+1000_xyhnSsjYLqYDs5YB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__24_Apr_2010_22_05_07_+1000_xyhnSsjYLqYDs5YB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jon,

On Tue, 20 Apr 2010 14:27:16 -0600 Jonathan Corbet <corbet@lwn.net> wrote:
>
> I have a tree I'd like to see show up in linux-next:
>=20
> 	git://git.lwn.net/linux-2.6.git viafb-next
>=20
> it contains viafb work intended (currently) for the 2.6.35 merge
> window.  Everything in there has been posted, reviewed, fixed, etc... =20

It will be added from the next release (probably Tuesday, my time).

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

--Signature=_Sat__24_Apr_2010_22_05_07_+1000_xyhnSsjYLqYDs5YB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvS3nMACgkQjjKRsyhoI8yxUwCfQHuRsuEiYGxQU7OumXap3iqW
RzoAoJDSqfCsOMvKU9gZ00OdZAeCYxgU
=xOEs
-----END PGP SIGNATURE-----

--Signature=_Sat__24_Apr_2010_22_05_07_+1000_xyhnSsjYLqYDs5YB--
