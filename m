Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2FKLRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:17:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:52595 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab2FKLR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:17:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="164102011"
Message-ID: <1339413676.2401.5.camel@sauron.fi.intel.com>
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Mon, 11 Jun 2012 14:21:16 +0300
In-Reply-To: <20120608154535.GA887@localhost>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
	 <20120608150736.GF21080@quack.suse.cz> <20120608154535.GA887@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZqTF0oRjrxhZ7zpSItFi"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZqTF0oRjrxhZ7zpSItFi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-06-09 at 00:45 +0900, Fengguang Wu wrote:
> I'm yet to setup and run xfstests regularly, so as to catch such kind
> of problems earlier in future.

You definitely need to do this before merging anything upstream. I'd
recommend to use test at least with ext4 and xfs. Probably btrfs, but I
never tested it with xfstests.

--=20
Best Regards,
Artem Bityutskiy

--=-ZqTF0oRjrxhZ7zpSItFi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP1dSsAAoJECmIfjd9wqK04HQP/0ztUXrMLlVp9hDrWpd3jP2+
+DL1Vs/D9JuI9lParYooTiF3uQ+PzEQsQDMHtPpKQ+y3eEMgt4FBDB6LcIdBSvn9
Qeobx8YLexMgwrQ05Sg/ca18HFv4UJphrlvAG6Syg7IsZb5oBnJ2zd3FH3X8oS0h
0soVfc6lcZfMPXdOEmu5Vjh8uRiyW4H0r1xu7OOShCvNtLg6m2V2pzKLxRxOCP/I
OfBzwi9YwgwWR+xmyCFxtko1l3eWQt7TS309jDQf3ANepJJC0COQTkws52GbpeHm
tnCLdx2zfVBtffkOYwyXTmFqKSsGzUhWQz2gcZAmG1STHYNfm9NlR5JEWwxGRmVH
R8zjoVpNvDS/iIa0lkoIw2WNQRTW99Pdoskhd2f1rCJblimNYkh8vmse38mUAtMZ
pwDg6LOt2BaJLVx0XoiCYk8atSreCRKhq8kjm9yDgnJ/JT8o2OXOcPZXFim9qrXf
VLKcnyUWcehn5ANX+MO9NipLVua0LOmpaOn0DlDeAk9GH2MLJwgGjN4zgYM+MIvX
OA6FcdSrqdbIowDGfOXu6jKtSSH9DYZXDGUPMpln63e7zZroSMzN3JTBPeqpWOeq
gp7+P0gDreoOPGfvrXJWYeY7ehg5t8HQLlzjhFjTY5uOCXva++NnEfmCPCMqvqz7
bErH7JUCBtaM4U0jUzyh
=qD0F
-----END PGP SIGNATURE-----

--=-ZqTF0oRjrxhZ7zpSItFi--

