Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161466Ab2GLR2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:28:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52432 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161266Ab2GLR2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:28:39 -0400
Date: Thu, 12 Jul 2012 18:28:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH v2 1/3] regulator: tps65217: Add device tree support
Message-ID: <20120712172836.GR7256@opensource.wolfsonmicro.com>
References: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
 <1341918584-28004-2-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24/piotZLKF/SXqU"
Content-Disposition: inline
In-Reply-To: <1341918584-28004-2-git-send-email-anilkumar@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24/piotZLKF/SXqU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 10, 2012 at 04:39:42PM +0530, AnilKumar Ch wrote:
> This commit adds device tree support for tps65217 pmic. And usage
> details are added to device tree documentation. Driver is tested
> by using kernel module with regulator set and get APIs.

Applied, thanks.

--24/piotZLKF/SXqU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/wksAAoJEBus8iNuMP3dgcIP/Az7K5iUFhWJ5Kak7CtG1icC
9BVT6amEhOGcXNQjA6nhi1Y6ajok+z+Ln0/4U/dbPg4yiXkNyn9TnALsV7L5Vcl1
c4H4zwfYQgLLGTXo2mZilTabNBVspYPKZmtodMHrajsTVUeZbV1x1aDFHWsqnNJd
bl8CgfaRrBbbotz7qJ3ojnsZWyDuhbsydI7c8h8ysgizFSxnClrFn4ekdZsE2+RS
i2jwO4VseJAH+/EaRGXoJx2wOh564uEGzvOrWd4RZb2drzCtqQHkMn8IUXwVtqTg
/UOaL5n8QHxNSOCFBsaNnXdnBKE14Rt4Kx8k1jIEWxPftKQRrCdVVQ3XZ6ZL+lJt
a8mbhNBD2aYDRLglXU2jkjC4qc2XHI7/MvOoQqc9krXfGuaUwwXkjRUSbuQGw6v7
G7lYWE3zBLOn0ESQPb4yjEiOqDEo/hkntD2CjbFEx4R7F57xoKm4LjntkEjUBPh+
2zceV9I/jlsY9vzRg6Yp8JSZfVKND4uGN5vK6zZi5eJziN2wkdHl7Yqnt2yuEcZu
UOuKDJaqh5QI1ea60+I+8i/CqoOHQSHjTGmeLEFhwI7boSjNPFDauM7lDsjEgpAe
XEaSuHW9eXhL742eKq3fKwR/C9qZeRqheNu6xYhp5A2VsoCCrKSe+QfiXdt5Ogfq
IJQRHLMV5fgKN84sIaDN
=sBGE
-----END PGP SIGNATURE-----

--24/piotZLKF/SXqU--
