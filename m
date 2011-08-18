Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1HRInq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:43:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:2500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab1HRInn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:43:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,243,1312182000"; 
   d="asc'?scan'208";a="39750262"
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Thu, 18 Aug 2011 01:43:41 -0700
In-Reply-To: <1313656307.32547.73.camel@Joe-Laptop>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
	 <1313653632.2128.88.camel@jtkirshe-mobl>
	 <1313654341.32547.62.camel@Joe-Laptop>
	 <1313654829.2128.94.camel@jtkirshe-mobl>
	 <1313655365.32547.68.camel@Joe-Laptop>
	 <1313655961.2128.107.camel@jtkirshe-mobl>
	 <1313656307.32547.73.camel@Joe-Laptop>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-i70eq9reeh4EgNtGvLEt"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1313657022.2128.116.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i70eq9reeh4EgNtGvLEt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-18 at 01:31 -0700, Joe Perches wrote:
> On Thu, 2011-08-18 at 01:26 -0700, Jeff Kirsher wrote:
> > I understand what you saying and asking, my point here is the that the
> > "default" style should be understood by checkpatch.pl and not produce
> > false warnings.
>=20
> And I still disagree.
>=20
> checkpatch should consider whatever
> input it gets as if it's a patch.
>=20
> So, if you really want to feed
> git log output as input to checkpatch
> you should format that output
> appropriately and the best way to do
> that is to use git log --format=3Detc.
>=20
> Don't suggest removing useful checks.
>=20

I understand what your saying, and I think that your suggestion about
possibly implementing a "--input=3Dgit" option to checkpatch.pl might be a
happy middle ground to resolve the numerous false warnings this check
produces.

--=-i70eq9reeh4EgNtGvLEt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOTNC9AAoJECTsCADr/EWUQ70H/1Tq2rt2MAwAAHTUaaCsn/xc
3PITsWH/3viNDxFHuT1/TGxxR9k6NdjAMlloRAhQaPNFLgE0qNqc5sTShO1jqSfv
VKC5OdNxUZE81jctccpBqOGW2IbY+RR8T3gR9aZJQ9IVJ//aRw2k4hvXjpXcaThq
yNB0NDHrrzD6Gwe/I2gSJdgeMXh44WV8ic6IDEd0Bfwf3LlOunwUFq+NiOZq0tdf
Aod8X7+4V8Ez+LkWKiHfRwWtQKIOctp9Wp4hkn2DuCIjxkV/6BkcM5EmUKdDPF6M
UqS5bZkJOdcX1PdpmO30FpT7Ska+D5hjyA3y2SPQEHL/aVEa43z0hKNcdrNWGVQ=
=mYCc
-----END PGP SIGNATURE-----

--=-i70eq9reeh4EgNtGvLEt--

