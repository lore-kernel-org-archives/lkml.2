Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2CHSH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:07:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36761 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563Ab2CHSHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:07:55 -0500
Date: Thu, 8 Mar 2012 18:07:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max8649: Use DIV_ROUND_UP macro to calculate
 selector
Message-ID: <20120308180753.GU3638@opensource.wolfsonmicro.com>
References: <1331172324.14592.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="50RDeE14MEV4qpyy"
Content-Disposition: inline
In-Reply-To: <1331172324.14592.3.camel@phoenix>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--50RDeE14MEV4qpyy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 08, 2012 at 10:05:24AM +0800, Axel Lin wrote:
> Use DIV_ROUND_UP macro for better readability.

Applied, thanks.

--50RDeE14MEV4qpyy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWPVqAAoJEBus8iNuMP3dcfwP/2zQ6sgWnNugGNCkfyl30pBI
t0uWdRG0ozumD1iQV2cZ5Gi7M3PNdP0xNoga3bqODF6g4S7EPlk9vftBR5maYiZp
PuMVq0RLkdAVXDf66yX+4Zijx45O+nXjUFV96+O3Oms+kBlNVfmS2a/fKUuvg1pF
ihw8szg3QE84BrtEp80mj+DHc7D0UQUjdBNheVzqJ1IuHuOjXTQ4QX9AXeZ9AXQ+
VHexHdJMZsu/GVy1sXi7CMaI8O4JzJ4M6+mCQP8CGKthvktvUxfsHKS/M/eO0q8c
GTm9A07CXEIVSZGG0YfObwQQcf07VnR521gfGoy6t7VRDBDRaFs+SE5Kyp6huKcu
wigD6T2X+/3DJUWM5a5BMXO23OMhGMyGCLdl6Kg4sqADISZVCNIo1M7eEmqU8x4w
u6NpSVWnv0zlQAVZu+1mFjeqWHLe+ZwqdYdeKIgHS2/geXViQTs2UYijCGnfc+kr
AM8splXBfw0BVb/CS2t4y2asUFJkHwwbimaJQKOPd6PCx+evhpMHfsMCLaeGR6Xi
tOgnxJ+y4GiaBWQRxqdNXhTFrUdJ/VS6crS6925ozVnmwM0hxtRGhpajnH1johxe
/mpX5FNDrhkIl4uwwN2Fx4WamPoi506Nazv9/oikKEcaOSNQO08Y5LS9k9dDs6ZC
XHnwrdGO2nlFE/YRO3v1
=Tm7x
-----END PGP SIGNATURE-----

--50RDeE14MEV4qpyy--
