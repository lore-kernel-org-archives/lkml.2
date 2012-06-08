Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215Ab2FHRJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:09:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:3094 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762120Ab2FHRJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="162972487"
Message-ID: <1339175573.2392.7.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: nand: Properly initialize 'mtd->bitflip_threshold'
 prior 'scan_bbt()' is invoked
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Shmulik Ladkani <shmulik@jungo.com>, Sascha Hauer <s.hauer@pengutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Mike Dunn <mikedunn@newsguy.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ivan Djelic <ivan.djelic@parrot.com>
Date: Fri, 08 Jun 2012 20:12:53 +0300
In-Reply-To: <20120608182906.57b4844a@halley>
References: <20120608182906.57b4844a@halley>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IRgjPC6P07ff/jHRc3DN"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IRgjPC6P07ff/jHRc3DN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-08 at 18:29 +0300, Shmulik Ladkani wrote:
> As of edbc454 [mtd: driver _read() returns max_bitflips; mtd_read()
> returns -EUCLEAN], 'mtd->bitflip_threshold' must be set for mtd devices
> having ECC, prior any 'mtd_read()' call.
> Otherwise, 'mtd_read()' will falsely return -EUCLEAN.

Pushed to l2-mtd.git, thanks! Sascha - does it fix the issue for you?

--=20
Best Regards,
Artem Bityutskiy

--=-IRgjPC6P07ff/jHRc3DN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0jKVAAoJECmIfjd9wqK06awQAIcGJz1V2F0dcl7FyQcchLAO
/jrBMaWtb1PFbVtxqxNSF5+ZtvmTfP55mxbzYSjbXZXvzbWKzpcIOv7DiNkrzf7K
smqHpEPqWmsE1kMNacFgnVMh0+VXw/J+FrQG/FnqbU9rVKzS3ymFx7yXNohka0LH
EBlGuak9O/eU+vfVMFJ15XWp3ieAsJ2BiH6G7hd0lF5xVpMnRVIByYRRrooHxfkw
qf1wNLVs3O3bLyqHDpctEPk5qn+PcT8G3KQxD+q8LVRdPZPoelikmPPt1MMqVozX
ppFDdiejLcdb5G5yn1a33oHO9KpdAAuzgKox/a+GyiRSrQQKGY6wdWX+hjWAUZJ9
KXQkloBw/2Zn1woyxwFudpah873w2oKzqnCJg4FufYER4j8DVSmIrxO+UsZIpmEK
di0sop1KWfP0RBRMBl9QHhEbK4N0/JPXvlrF2qCg351sokLyg1uuJ8ZYJ0Ir8wY1
3AB2sWIotnaHU9duIAdaxCX7j/KkgcBRdO1zUHk4+SEi2nS4JOHWcO51zmLwMxtA
635ZIXzRnbzOt7s5DvWQSc6Bplb82NFtkCL35d1KEPDwvZQelORjW+RqjLvAe2ii
KJc4fgdUQQXQ70sZV+K54ITfF+f5YcrbASPo+gOTe/EFjbyS/4CyTDIwr2934lDW
I+iz+MhKjvfEu4Swfpmg
=Hll7
-----END PGP SIGNATURE-----

--=-IRgjPC6P07ff/jHRc3DN--

