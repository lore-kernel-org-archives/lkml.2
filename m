Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2K1TU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:20:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38041 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536Ab2K1TU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:20:57 -0500
Date: Wed, 28 Nov 2012 19:20:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT RESEND] regulator: pcf50633: Use linear_min_sel and
 regulator_[map|list]_voltage_linear
Message-ID: <20121128192055.GD32691@opensource.wolfsonmicro.com>
References: <1354070464.13461.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aDj5WtVma0yWCzS8"
Content-Disposition: inline
In-Reply-To: <1354070464.13461.1.camel@phoenix>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aDj5WtVma0yWCzS8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 28, 2012 at 10:41:04AM +0800, Axel Lin wrote:
> This driver can be converted to use linear_min_sel and
> regulator_[map|list]_voltage_linear.

Hrm, actually this was already applied.

--aDj5WtVma0yWCzS8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtmQIAAoJELSic+t+oim9nmwP/2gWrroOk4sUzi9qTwjj9vBw
i47z2CKyyBAwoLTo4PFod6kB671bRN+epW6i4GyuQPsW8mvybCVKg7gx3vrSXdyo
cDglJfVUPnhsFrgZ4ECmjkZzAs2hwxVkUuA7lEJL5SPpybQJPeWXgLgC9B0zcPcO
EB4KrTmhWrJiv6s8t58ixfgjVSXnqD2WzLzi/WP1+vj+1yZSU7qsRK/CSuxFOgfv
5De3xRrhSdHhHc4hGyCXj9Xq9Lq+dcZPm/SmCE3bNdVBk/PWXQd9QC3wz3CZj89b
Qwv5Wq41zsGhzMIhV5XwSv8gs/l4PWqllWNUfXQWD2a4A88ELwqdHZsFxyrSCo8T
0nGYvJeHmuEHufVYhKpp6p3Nhw8eNz/7fnX/MeTqBUA0cXHnigzaxQdPhtGeuY1k
mAcdPCMQMWrtNIb5+CDnm5/Xs+nzqujc7HAPDz/v/piJPZ1O9Q8p7FsGWztW6Qyn
vzTEPZ6eUbdJmLMQPV5q79eEmrxYNpfrFW+z4WCNACNXw+8CgF80VClfVnpnuVZf
zwIo4gIqcqa77CEWxpQUZScaoaaSgBEKihKP7wkJFaxUzzGGbdivX+ist6c4lJ2x
Nhfsnw34qANlh18VlqbS4NxErkATe3LisUkxCZs+z6IskyBXsQalDoTw9nXPW5vF
LoKbXofo61Vnfxn0pcLt
=p/9D
-----END PGP SIGNATURE-----

--aDj5WtVma0yWCzS8--
