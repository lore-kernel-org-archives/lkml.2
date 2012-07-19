Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2GSBSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:18:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:57199 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab2GSBSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:18:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="124129795"
Message-ID: <1342660700.2616.12.camel@jtkirshe-mobl>
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Narendra K <narendra_k@dell.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Wed, 18 Jul 2012 18:18:20 -0700
In-Reply-To: <20120719111510.478d62e4f0778bd0de1f4c66@canb.auug.org.au>
References: <20120719111510.478d62e4f0778bd0de1f4c66@canb.auug.org.au>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jF1SSGhB941y1SBdPiYI"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jF1SSGhB941y1SBdPiYI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-07-19 at 11:15 +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c between commit
> 936597631dd3 ("ixgbevf: Prevent RX/TX statistics getting reset to zero")
> from Linus' tree and various commits from the net-next tree.
>=20
> I just used the version from the net tree.

I will take a look at it later tonight to verify the conflict resolution
is correct.

Thanks Stephen.

--=-jF1SSGhB941y1SBdPiYI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQB2BcAAoJEOVv75VaS+3OS7kP/jk3ehYJHdmXLSPeJjRJZ7R9
2CqkfK+zg3eK6+UiZeCZIYFOEKAVMfw5kdnSpsqlglxfrVU1CXfBmiUQec8SfgmX
pdfCxWXsnIdBPJT3damfpPdEhYhoMBLF+WXBI4AeZ2kZ4Rc+YlFcYVDTXQjzSP3r
Xobk929Dd/KKKBkgyDPhdxeYbzS5x8+V9XAg0calOnV/gK2R6OisDueZnn5nv30H
6Nb2uzaBQr2b4Uwv+iXAcu0UqPFdBrw0Xp7zWrWIG8ivB7UpetD87x6AfKDrC7cH
0V5G6LuUk9tHZ5h6zRfLTm00HBOsCXocfXlqvGZWcR/DOqp6aQ1qpohYX6zSQ7op
RiLzc2M+cXXuFX8X8pEw2eJAUUhi1Y9BtkeT6hDJ8fHLqRkVYiw4r5KhyWHdPmGc
r0xbKI/re98WQ2RM79VcGGkm/A4GB3Y9eUa+6mBQEwSHhQMOhRoKTx1G4dZqcb2D
fxMGVpmOOvGKKS0D6VFyKQNX+7dXjSQW6uD8TsuNMErHy7jCXd8Pph9ptTQnS6UB
OBw+AXKHs1Ha4S3MjR33NHCjQ8LFNLNDMZREvmaqwNxlrqtmo6+zZGVzK/3BxrW6
14my4C5LHOuIjzkmEWPKWRGa2BJb234hqpkScs66xFt5njunoiQ0xCyCb+EDxjbD
77cqYvQSWvtNASvXEBi2
=YT0r
-----END PGP SIGNATURE-----

--=-jF1SSGhB941y1SBdPiYI--

