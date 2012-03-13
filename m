Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2CMOim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:38:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:8965 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2CMOik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:38:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="118285726"
Message-ID: <1331649633.3595.70.camel@sauron.fi.intel.com>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the vfs tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stefan Roese <sr@denx.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Joe Perches <joe@perches.com>
Date: Tue, 13 Mar 2012 16:40:33 +0200
In-Reply-To: <20120313141859.302878a8e2246979c288440d@canb.auug.org.au>
References: <20120313141859.302878a8e2246979c288440d@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fxWckKyBgNztmx2UICJY"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fxWckKyBgNztmx2UICJY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-03-13 at 14:18 +1100, Stephen Rothwell wrote:
> Hi Artem,
>=20
> Today's linux-next merge of the l2-mtd tree got a conflict in
> fs/jffs2/fs.c between commit de071e1a7466 ("switch open-coded instances
> of d_make_root() to new helper") from the vfs tree and commit
> ab9b393d6ee8 ("jffs2: Convert most D1/D2 macros to jffs2_dbg") from the
> l2-mtd tree.
>=20
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks. Although I do not see the latest l2-mtd.git tree in the master
branch of linux-next, I see some old version of it. E.g., the jffs2
changes are not there.

--=20
Best Regards,
Artem Bityutskiy

--=-fxWckKyBgNztmx2UICJY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPX1xhAAoJECmIfjd9wqK0wxcQAJJTlUMM8orZg6pjFKgIXeFZ
3ikDpLRbCezQNA63erar5eIexrqmgcHlnTDYwwjbMZ3rqMQurnXFXfgtaveAgbXq
sSA+kEWeAIDlov0ouTgzfVqGBHH/0qvkbh7+YL38Zm4GbRONULjbSgDutXkbl3Oi
TqQ+snV8wx+3Vz/QSyXmAHtbrl9GY6ezs4o0hn9n2D6i7D/0mtVSThtJ4RvDAAI0
x3NiHuz2Nz2E8Xyc4hr1YA1TRvj2ESccOy1MZR0hsYa+CxL4E5Rxi4oZX3eYwqLm
Inlz9vJZ7qQFFn9/KKYj+ELNdY9yqOFd9hAUttUiXNazh8IM7aHaIzLk4yJ1lKrR
I7H7muJfTNJJTsZdjOkbIP5jUpVugEnJdiCCs7yT93nTlixKgSym+O5wxb/u6XA8
XHGnCO040jz8uAuAT6zfBNx2sllsKyKeHr8i1zBuwkOaDdNOZmdMZVmqitUmALgF
J36g805mZLFSbuSLh2xeUyyXzdeyalZ+IW+J4ynagr7NA5JCNJNLN4XNqtXiksLt
RtsaPS5uIG1xvXvyqoVTDYYnhJZKgqvc48gkX1n7cRIwwmVhKLzNIs6vMOglv0rd
e+VJc/tUdK9YGXG/t/JXzmMPRTUwpN2SF3SOqEZWXRPG0CdinjB7J8y9ghGJ9yHf
tZGedkeIAj/Qsoxg5lPm
=t+Xn
-----END PGP SIGNATURE-----

--=-fxWckKyBgNztmx2UICJY--

