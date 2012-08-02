Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2HBSq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:46:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:34697 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab2HBSqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="180860926"
Message-ID: <1343933454.25013.224.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Date: Thu, 02 Aug 2012 21:50:54 +0300
In-Reply-To: <1341836323-43916-1-git-send-email-richard@nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4sGk72btFe6WMSXsMC7q"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4sGk72btFe6WMSXsMC7q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-09 at 14:18 +0200, Richard Weinberger wrote:
> This is the next round of UBI fastmap updates.
> It fixes all issues pointed out by Shmulik. :-)
>=20
> If you want to test fastmap you can use my git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v17

Richard, would you please rename the 'fm_auto' kernel parameter to
"fastmap_auto", which is a bit more user-friendly.

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-4sGk72btFe6WMSXsMC7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQGswOAAoJECmIfjd9wqK0insQAI8mpnKxO8/ObwMpKUfTnyEk
zrHgHZb+J0Fu7NNbVXqaSjK1I98MStmQQmRSx7/VmWNwqzZT/PbHsUo9ELNvtjmP
ODE/4JLZgSQqysZ/NvUe1myO+qjUp0vTJmAgwOsHx25LCHwxJcJJIcxgLFkXJJNh
Bk12NeAWaXJa28GJOJbYKN5tcHOfwAavDgJh11xEDtxNMUI3LfCYKoXGoatHpDMD
+PgZ9Pdu4/xYA82KhHOgSX5uiqpKBoCD81pj4X2YW/AszVfiEABmrdS50oGWVPMB
u3j8MnNBTAzGtbm2vhWVsDitWySGWho9uWHJeHfByXRo+XzrPz+REEntG/imqs7n
r8/hxjZyryY13F2PHirtqNBZ4ixgO3NTI17FzkBWIC0QkBa2JgmSyUdDrlRLS+28
i4r3ojW+umldBenYPK+GrsmdxsJBbuD1XOdYtyoZgjz3UnfeM5y/Lh7llbnWSwUo
n4UlINTLizzGkgv/K6VB4iMF/AJLLCDehNLnCNzwyr8eCdzi761KypOdysrZU9JU
7pZiWivZARcQwi9W2LXEVEzG216tvXt8GRInPsZWQkFUn7gqWTV3oDqHmDatQjB3
esTuOkvX6tf0K4e2fLgsJS+wqlJqO+J7/JBCavN8hmK88jm3RUBMDDiHWCTmTW2O
dpD3LSsJjYEtNsh6WNaH
=OUeG
-----END PGP SIGNATURE-----

--=-4sGk72btFe6WMSXsMC7q--

