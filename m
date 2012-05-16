Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2EPOp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:45:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:39844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab2EPOp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:45:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="144708117"
Message-ID: <1337179769.24809.66.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ubi: add volume id and LEB number to struct ubi_scan_leb
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 17:49:29 +0300
In-Reply-To: <1337178865.24809.62.camel@sauron.fi.intel.com>
References: <alpine.DEB.2.00.1205161419590.27131@eristoteles.iwoars.net>
	 <1337178865.24809.62.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VGXf697C2CPCzbVffhQ8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VGXf697C2CPCzbVffhQ8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 17:34 +0300, Artem Bityutskiy wrote:
> I've added this code to the joel branch. But please, test this and
> other
> UBI merge candidates with all the UBI debugging checks enabled as
> well.
> Similar to UBIFS.=20

To do this:

1. Mount debugfs, in my Fedora it is already mounted:

sudo mount -t debugfs none /sys/kernel/debug/


Then:

$cd /sys/kernel/debug/ubi/ubi0
$sudo sh -c 'echo 1 > chk_gen'
$sudo sh -c 'echo 1 > chk_io'

This will enable "general" and "IO" extra self-checks for UBI device
"ubi0"

--=20
Best Regards,
Artem Bityutskiy

--=-VGXf697C2CPCzbVffhQ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPs755AAoJECmIfjd9wqK0pswQAIVEk0T2fvTOW+vhsdqyKXfA
vEdEO6qEpCRXIkATlhi3qOd/oCSyUxaUyailHETBcd07vi8YJIvWd84uclXXHdUw
VSEaQJERFnWk8fw4sTkDNJJhOcm4shmputIpqgndJs7smke7fzJrJrXSE/8W+v9e
ZCjZkuyY7wEcqTrOU6DbMQRq/NOz14SEx8qh2/jtVQ4kDsnJkX8PVZDaR9AML0HK
GYFq3qdgqS/x7KUyr3zYM5coBzfcYdAvtOx1u7NzILZCZOPkxSPfb5QMWnB0ECXg
0aKy/A0hhCcgQ8gWatxNAleeVbIjLCKbugqz0gxzpMxDyPQMI8FncNpSEuJjscU5
9OACzAcBU8x/AYf/zwDi3GpQEYVae7pxr4rVFDrbBbz6GDqsACG+zuI3+OMgJLV3
bcThbQqMfk22zdQ5smLvY68BcHGtFA/dLf3+XTGn6hLFe9pPUI/aw7uONfq0fe7m
/TaoNfXU6FbcUCzVpLnBmNbda7Tw1QPJOlo9rmYZ8RGtJsbghbtsK86zCESOBnrq
/5N6rlesS12rGxdiqjLe2qeIsB0frfupta6mfsC6es7o2nHPXA3M0m2Q6/1OM+oF
0Y+mBzVq51MHzNzk8MbtTm6/qRCKydb2MSmwtMKOdja0nv0QmPDFxVtE8ihfvrsR
Fwoj2hDf3D3BcWRiHWYJ
=VJ66
-----END PGP SIGNATURE-----

--=-VGXf697C2CPCzbVffhQ8--

