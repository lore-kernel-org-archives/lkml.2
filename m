Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab0EUGiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:38:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36360 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab0EUGiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:38:52 -0400
Date: Fri, 21 May 2010 16:38:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tom Herbert <therbert@google.com>, David Miller <davem@davemloft.net>,
       <netdev@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the net
 tree
Message-Id: <20100521163844.c702a2b4.sfr@canb.auug.org.au>
In-Reply-To: <20100521162134.6b6326bd.sfr@canb.auug.org.au>
References: <20100521162134.6b6326bd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_May_2010_16_38_44_+1000_fHd6_1MLdCRGZTiQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_May_2010_16_38_44_+1000_fHd6_1MLdCRGZTiQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 21 May 2010 16:21:34 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the driver-core tree got a conflict in
> net/core/net-sysfs.c between commits
> 0a9627f2649a02bea165cfd529d7bcb625c2fcad ("rps: Receive Packet Steering")
> and fec5e652e58fa6017b2c9e06466cb2a6538de5b4 ("rfs: Receive Flow
> Steering") from the net tree and commits
> bc28c84244da26bafb0d3bce95ef45212b31c6b8 ("net/sysfs: Fix the bitrot in
> network device kobject namespace support") and
> 83dc0fbf37495691219d019ec16b40d8592d2956 ("net: Expose all network
> devices in a namespaces in sysfs") from the driver-core tree.
>=20
> I fixed it up (I think - see below) and can carry the fix as necessary.

The net tree has been merged by Linus, so this should be fixable in the
driver-core tree now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_May_2010_16_38_44_+1000_fHd6_1MLdCRGZTiQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv2KnQACgkQjjKRsyhoI8ykJgCfd5vyX0JpiD9mNzCBu2zsk8/J
Z7AAn3WkgSXLNe9Um8+K1S4ObxHpDRUe
=1kmK
-----END PGP SIGNATURE-----

--Signature=_Fri__21_May_2010_16_38_44_+1000_fHd6_1MLdCRGZTiQ--
