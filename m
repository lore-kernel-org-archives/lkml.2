Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2J2DVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:21:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57107 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2J2DVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:21:36 -0400
Date: Mon, 29 Oct 2012 14:21:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: linux-next: manual merge of the akpm-current tree with the staging
 tree
Message-Id: <20121029142126.66314d5d5898d1a9070e3171@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Oct_2012_14_21_26_+1100_FuVF78tz/Ixu3I/9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Oct_2012_14_21_26_+1100_FuVF78tz/Ixu3I/9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
drivers/staging/rts_pstor/trace.h between commit cd2112220b6b ("Staging:
remove rts_pstor driver") from the staging tree and commit 3980a6d4af3e
("staging: rts_pstor: use kbasename()") from the akpm-current tree.

The former removed the file modified by the latter, so I dropped the
latter patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Oct_2012_14_21_26_+1100_FuVF78tz/Ixu3I/9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQjfY2AAoJEECxmPOUX5FEpmIP+wYCJnKYkZGSU5fiBRQrDKR2
RXTk64W4AttP3OdO6hY1td/cm1rosCUt91AIRB4LgKbzDWS0/Jr4U7yixGtHxJWc
aQXMLZK1VmeoCtDWUQwBV4E0lcDvViSMqn1VFB0AULfei8IMvk+VoQLVVVDxZQPi
qF2b25ZBwx69RdVw6gIsQZPQgkWjzJrwvnfJCQpdg+2uS7hntfeBM6hroPjPrTpz
n0qvt6wzfs3ahhqXornVCum4X5+s6z/biXs+hJWRzYAJj7gzCmkgt4el1PoKF0/B
UAyX+gLtP5voI7l6wUngqnJ0U1VOnstw3lNK59rRi+xXwdrPchymgAbwiLMA730F
9PWY0w0dbdeW4eicTuBfuZlLFQSsfl4NZ9sSN5XqTnlX6n5EQUsTScDHKppZUuRv
mcbPXrJyaVz1Q6+7NUH/ZtQj8LqdY7oNxqenhWp6apdwJH3+D0EPy8+8V/espfmv
1lbuqkuLyVdddG/dWytFEVoKdUX45VgoHyqzdlJsnEJrM6rWyxQT+CD54UNVH65I
7weUOz3XpLVp5v8C2Dp77xPayK5ox4PeVxEPYY7xyUG0vi2WLY83eee/nYYrkgQV
rQclGrBdjEmNemj8IHyLYjJskmOvjEExCJXLhsukgXQbTgGGUe3O7A1K5iVLg3F6
eOQ3YUkvwcOR9211fA1R
=rckE
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Oct_2012_14_21_26_+1100_FuVF78tz/Ixu3I/9--
