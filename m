Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab2EPGvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:51:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:58216 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759140Ab2EPGvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="143767633"
Message-ID: <1337151273.24809.2.camel@sauron.fi.intel.com>
Subject: Fastmap - please, review and test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        Heinz.Egger@linutronix.de, tglx@linutronix.de, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 09:54:33 +0300
In-Reply-To: <20120515224645.3af023c3@halley>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	 <20120515224645.3af023c3@halley>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-E3V4qMSLNpij7KSIyWJw"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E3V4qMSLNpij7KSIyWJw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 22:46 +0300, Shmulik Ladkani wrote:
> On Tue, 15 May 2012 19:11:04 +0200 Richard Weinberger <richard@nod.at> wr=
ote:
> > TODO:
> >         - Artem is fully happy with the current on-flash layout,
> >           maybe I can merge the erase counters into the EBA table
> >         - Get a full review :)
>=20
> I'd be glad to take a deep look of the code.
>=20
> Hopefully I'll get into it in the following days.

Thanks Shmulik - I appreciate any help as much as Richard. I am busy and
my job now has nothing to do with MTD/UBI/UBIFS, and I have limited time
for review.

There were many people who wanted faster UBI, and I'd ask them to
participate now - review, test, etc.

--=20
Best Regards,
Artem Bityutskiy

--=-E3V4qMSLNpij7KSIyWJw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPs08pAAoJECmIfjd9wqK0L8cQAJlzXKNMgA5zNFJAYk9iggQb
MxSW2f6WoCMWPt17ByuTruoVlh/KTWJqeFMDkzV38f+pSxySQcoGpGpcyGfpsSlF
WtGjddOBbjWYiboDwW4RDgT4pCdcZoICkRPpUBmwv6nBhHE3M5YFlijcJLr7uu0f
UypCAkH8VGir9xVWNnkW/BRgvm1GgzH1ixEYtjuuJ/BFhgba09l8j5xIeBGB5FCg
vNaFinBIWlMABltL1DjIndUpZiFPBonQVcdEjBWxm9z+ZSPs2fNuQERQj+XtBS8N
DvX14HFZjGiM3H4o7eR88tUlp8qfYLvymJb76g+04f3ImLcJ0D7GsxwZCGPbiOtb
zImqaQhELM1ryXYoLj/Tx3bcVfBYlS6Pa8FbOVZ/3bxjjGj57Xm6N6TOd7VU6rdi
UZxXJXJRujlNFxbqw/zSJXrK2FjmCcHaEQcUe6BB1f9bDWI7etW+oRt7RJNLVKSV
w4/c2gkSVY6Vwi3W92TrzTdOpmXxcrdr7/2pGUViQD9cngvr2kGkCyMUNTZwEfGp
R4rBGdSquZ6UrFMg4bF9tIQakoEX54dv/tCVSHv8U+vk+wrkhyKxEtoncXMpvIIt
0LlIFRSBXCsccGHiWAksRDVV63fADWuLtcAAUwZMYUMakIopcb7LtEBL0epJdTVZ
9nEg9VOvHHWaZfjIzywg
=ORvS
-----END PGP SIGNATURE-----

--=-E3V4qMSLNpij7KSIyWJw--

