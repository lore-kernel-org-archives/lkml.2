Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798Ab0DHW70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:59:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40248 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933762Ab0DHW7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:59:24 -0400
Date: Fri, 9 Apr 2010 08:59:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: John Linn <John.Linn@xilinx.com>
Cc: "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jtyner@cs.ucr.edu>, <grant.likely@secretlab.ca>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20100409085918.cc984fb1.sfr@canb.auug.org.au>
In-Reply-To: <6125d80a-81d5-4699-ac6e-9408bd0c1145@SG2EHSMHS010.ehs.local>
References: <20100408153505.eb205158.sfr@canb.auug.org.au>
	<20100407.232500.184442638.davem@davemloft.net>
	<6125d80a-81d5-4699-ac6e-9408bd0c1145@SG2EHSMHS010.ehs.local>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Apr_2010_08_59_18_+1000_/czZ1g_0yUPRmo6+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Apr_2010_08_59_18_+1000_/czZ1g_0yUPRmo6+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Thu, 8 Apr 2010 08:15:12 -0600 John Linn <John.Linn@xilinx.com> wrote:
>
> I'm not pushing back here, just trying to make sure I understand and do
> it better next time :)
>=20
> I don't see that my patch has touched that part of the driver as that
> call was already in the driver before my patch (but maybe I'm just
> missing it).
>=20
> My patch did change the dependency in the Kconfig so that it only
> depends on powerpc rather than powerpc DCR and maybe that exposed
> something that wasn't previously exposed.

Yeah, virt_to_bus() is only defined on 32bit PowerPC, not 64 bit.

CONFIG_PPC is set for both 32 and 64 bit PowerPC builds.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Apr_2010_08_59_18_+1000_/czZ1g_0yUPRmo6+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku+X8YACgkQjjKRsyhoI8y32ACeOsJXHXLdFZ2R4RVgAQ/OyKLO
4OoAn2Sr376br6xqoZ7liapSeWtO1YPs
=HxCw
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Apr_2010_08_59_18_+1000_/czZ1g_0yUPRmo6+--
