Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2K3LZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:25:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:38331 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996Ab2K3LY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:24:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="asc'?scan'208";a="257106923"
Message-ID: <1354274749.30168.100.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH 0/1] ubi: Add ubiblock driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Fri, 30 Nov 2012 13:25:49 +0200
In-Reply-To: <20121121110022.35db364f@skate>
References: <CALF0-+WuaUn5b=2XrzqW7pvM=N1MfQf=sFwLFOrokTkHbOXh3w@mail.gmail.com>
	 <20121121110022.35db364f@skate>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-i2CwBWG4xzGI4IyrUVcu"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i2CwBWG4xzGI4IyrUVcu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-21 at 11:00 +0100, Thomas Petazzoni wrote:
> While I think the original ubiblk that was read-only made sense to
> allow the usage of read-only filesystems like squashfs, I am not sure
> a
> read/write ubiblock is useful.
>=20
> Using a standard block read/write filesystem on top of ubiblock is
> going
> to cause damage to your flash. Even though UBI does wear-leveling,
> your
> standard block read/write filesystem will think it has 512 bytes block
> below him, and will do a crazy number of writes to small blocks. Even
> though you have a one LEB cache, it is going to be defeated quite
> strongly by the small random I/O of the read/write filesystem.

Well, in practice normal file-system do 4K-aligned I/O, without crazy
things, and try to do I/O sequentially.
>=20
> I am not sure letting people use read/write block filesystems on top
> of
> flashes, even through UBI, is a good idea.=20

Why not?

--=20
Best Regards,
Artem Bityutskiy

--=-i2CwBWG4xzGI4IyrUVcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQuJe9AAoJECmIfjd9wqK0JH8QAMEXkfGsP2PYdfTSjhJWedZw
PbHELNoFTjFwlGzRCV3ulDzx/QnQXiyIS80ZZWQO68KCTNhCrryCouJRp6uWANYR
jzZboy8hCkK9I7kbLtLEbPHXhzM7awAIhKMAsh1d4k5L5/ywIZUouyhYXO+01gLj
MNszGGTQllTDGwpaqLJLcKmo7RL1GjOUUspiKkzjIc0zIwD64ThPTxa4hcCYzU+2
3xnDk6x9BlInw1E9FV/tFVnVDUXTomYMMFOkkjnr7gaXJees7TAUp5U/7Mf7REQA
oR0+BX55LBKAx8h+MCORA98FFeIR45qYTIXnEBEZ5kCPJt4v33YMtyu7FzbjRhpm
PdLhSwwGnNWlumVuKLeu9stb9nxNoOoAZ1XzJJKxUHqbFMn/MakmYHilQv6ZWsP7
kU8vcrXpEvhcg95vH+MW4T8mYIY4+7luZ7oOItOrW7bINVUNPBXDm6jXx8ublZRP
ovcxUN1JbT+lsoDqqf0fX5/d49Kd+cn/taGFAhDCwQ0Fe4A2iV+fzEPlctkF4JSn
yKsVizY4xhVRArNVJTIZpeSbkFP53sXYuNcJxhqHLRj3flkRUSuDIT3bM2Z6fd6O
5zETVWw7VdyqSHwNtMYfNB2Ya6Ma8y5dP2qi0+W2TqovW4Ioxtv2/Pu7Zq/DH/Kv
jDgaW6Da62lPbi7wCtfs
=OlJK
-----END PGP SIGNATURE-----

--=-i2CwBWG4xzGI4IyrUVcu--

