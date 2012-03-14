Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905Ab2CNMXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:23:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:43483 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab2CNMXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:23:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="117593120"
Message-ID: <1331727939.3730.8.camel@sauron.fi.intel.com>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the vfs tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stefan Roese <sr@denx.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Joe Perches <joe@perches.com>
Date: Wed, 14 Mar 2012 14:25:39 +0200
In-Reply-To: <20120314021312.c15dc02ec501ceb0d98ea755@canb.auug.org.au>
References: <20120313141859.302878a8e2246979c288440d@canb.auug.org.au>
	 <1331649633.3595.70.camel@sauron.fi.intel.com>
	 <20120314021312.c15dc02ec501ceb0d98ea755@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-haTW18qYd24n+NwlMLyt"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-haTW18qYd24n+NwlMLyt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-03-14 at 02:13 +1100, Stephen Rothwell wrote:
> I just checked and the master branch on
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git is
> 8ca39b0 "Add linux-next specific files for 20120313" as I would expect it
> to be and the top of the l2-mtd tree that was merged into that is
> 4331c79c6895 "mtd: do not use plain 0 as NULL".

Oh, yes, sorry, you are right - it is there.

--=20
Best Regards,
Artem Bityutskiy

--=-haTW18qYd24n+NwlMLyt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPYI5DAAoJECmIfjd9wqK0FucP/15GvjkYD+TLseOXOQdTKwKI
g26F+H1Npz/NM9FagUueEd1eZwOtoJ0Bqy4KNWFniZDxs8dXyL4Er9Sv/T2nXEcn
zdCDLVM/im7/HzhoTQBcznjO89+M98NDCs7qrV+4HQk8T1jGzxKmlVEM2JpGY4ZC
idysy6hz8ZbHqS6yyMWAeOaMFVGYTapIf/M/671n0Gq6zzFWbKoARXlbSXgaSeB9
t977aoD3FIcfjhKej1p6VR2qW6Xnxslm9MJur+sleaeE3szNdIVgQIcd6rkXM5lC
MvMa9pSYxqv6FzL0vSVteW8QEOXbg9n3fslD6ss+HkUqJwWGhGGZfWPn+6TFkJm4
u8qJ3wDw9KF5Ws3NFbsvqrR3+gBHm+ZwIByWsh9TceWJqCEcYhCVyD7cMOV65v8f
1tAIFg3aARVeID2+Q/LObEvUUE0I+36KHm7wio87wcKlHskQrda3Xf5kKqP77zjw
VcJSKBCn40GJa3g2QmF1qgRmFG36hAOFCoCNAQ/tap1mwZLQ7zt+LiBwybT8W+Yh
BlZPcaFprlkfqJ2hmM2na+nk9JC8h7GstQhh7kjBP3WTGUppmLtvpavCA6A8hh+Q
20PvrCewT0Axf9incmAJoX5e7eaH8b5tqc+lDirLvop60Gd2ljQoWNdLXlvJ1Eyb
Y7OxouyW5mBYZC0A9rJB
=7zc8
-----END PGP SIGNATURE-----

--=-haTW18qYd24n+NwlMLyt--

