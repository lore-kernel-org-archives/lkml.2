Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2AXXIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:08:02 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41994 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab2AXXIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:00 -0500
Date: Wed, 25 Jan 2012 10:07:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>
Subject: Re: dmaengine new location Re: linux-next: dropping trees
Message-Id: <20120125100716.4ab6e97c6e7ec6bded4b5f8c@canb.auug.org.au>
In-Reply-To: <CABE8wwsnQUJeHU7FoK0VkwRVRChVF2_7kQQPfPvtCOr2eF9hcw@mail.gmail.com>
References: <CABE8wwsnQUJeHU7FoK0VkwRVRChVF2_7kQQPfPvtCOr2eF9hcw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Jan_2012_10_07_16_+1100_EZiCpeAqytnfA3iW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Jan_2012_10_07_16_+1100_EZiCpeAqytnfA3iW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Tue, 24 Jan 2012 00:40:55 -0800 Dan Williams <dan.j.williams@intel.com> =
wrote:
>
> Please add:
>=20
>    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine.git next
>=20
> to -next to replace the old async_tx.git tree.  It should be included
> in the merge order after Vinod's slave dma tree at:
>=20
>    git://git.infradead.org/users/vkoul/slave-dma.git next

I have added that from today.

Just for completeness:

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

--Signature=_Wed__25_Jan_2012_10_07_16_+1100_EZiCpeAqytnfA3iW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHzmkAAoJEECxmPOUX5FE4QEP/1OxIvtIxelQyUJarVOLxJKR
bLGq0jUF2BDwiwqspJpQcrbilY3+Z69T5a9+kobrC39mMa78lzD2stT+Bv80eCVY
D8AXLv+b8O9xRuDd5TklZdUxW60Ot6cz4RdnSu7+T01k1hJVxR++N80azrX2CVcZ
SPsOhbT2oywop0z7b6BeN3EyHmBvl6aaw8GPlAkQVUdRLKMaWMaGCwc1O1J+r//B
pMiipB3aKjngmiFf/xZUrMXwlQclXf3g7KLy+EheKEmeaSpqbAqxSQ5MHi0Rx6o6
FnZiBiAjdKR5Xm0A61jOGmJB26I2dL87MzhBFsvhUeVXNr/sPkjkAH0oJRa2Qw1c
crc4TRo7A8vz6K6PJsOA9pkgB6c2F0LXf0k/XeJt41RIuvDaLRgfo51BcAP052qg
Lti0uv8ku+g05Ht9jfChHR2AqeaKR0w9HtJOTgBGfNhcQZDI1YNkuBGabgR2iD16
LznoqS+7jrRHla0P+rHhUqWYYfsXl/qW9zb1sdlupfBIxGGnaWrJeKqFgXlQwaOS
qQSRxPGXzwMiiV5SWvcsHExDdy5mwUWn74m2Y0qC1R+Cowd5Ar5AexT6VlvWDk87
gBAC/8X9k2+xv8QrXyeEikXEyM6NOj1vaVpFNd/6aUK5/fzjNR6J+HYRV1/QNQtW
3YduQHns9mtt0/1sYZoY
=SzwJ
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Jan_2012_10_07_16_+1100_EZiCpeAqytnfA3iW--
