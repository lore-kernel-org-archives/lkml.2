Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1AMG0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 01:26:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53028 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1AMG0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 01:26:08 -0500
Date: Thu, 13 Jan 2011 17:25:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 1
Message-Id: <20110113172557.c016ec51.sfr@canb.auug.org.au>
In-Reply-To: <20110113053554.GQ19804@ZenIV.linux.org.uk>
References: <20110113053554.GQ19804@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Jan_2011_17_25_57_+1100_5rRg6soiZvNfoY/A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Jan_2011_17_25_57_+1100_5rRg6soiZvNfoY/A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Thu, 13 Jan 2011 05:35:54 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> 	Contains: d_op series on top of Nick's pile, a few other patches
> from various folks.  More tomorrow; there's a huge pending pile here.
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

None of this has been in linux-next.  Some of it seems to date back into
early December and even November ...

Merging it into today's linux-next produces conflicts against the
ecryptfs and cleancache trees.

It would be good in the future (as I have asked in the past) if vfs-wide
changes like these could spend some time in linux-next so people know
what is coming ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Jan_2011_17_25_57_+1100_5rRg6soiZvNfoY/A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNLpr1AAoJEDMEi1NhKgbsNzMH/jJMc4MUu1H7Sr9hlFtUnhhi
c69XXEgAevnAfjermhgQWT4UQa3D9OBbp8zMPmWBPjYiplr0zVnvtCTNTr7Don45
bU/rJrcgWCzLYLSxWZBVf0yJ+/oYbrfsK7yVEXWEtI7t71WI5K8WHbJReMeauhA/
HvDHRmYbay4M3TGDaDTL6QdI1wVpoHtvqknwdYwGOtl+CFx0061xaM7tyt1bJVg5
ufxI5DQyfah1SP9gxbaggQjigxxU2cDeEutme/IFEDIhnQTBFirBiFthtUQrtilV
Z/qoyg4FFb/WrPx4FZIJMomoi/fwc4rVFAwnuoEc1ybn5jZCH0uadi1AylCVeaA=
=yZ/o
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Jan_2011_17_25_57_+1100_5rRg6soiZvNfoY/A--
