Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab2JKJ5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:57:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:16206 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab2JKJ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,571,1344236400"; 
   d="asc'?scan'208";a="203191842"
Message-ID: <1349949469.20594.67.camel@sauron.fi.intel.com>
Subject: Re: [REMINDER: PATCH 1/1] mtd:nand:clk: preparation for switch to
 common clock framework
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>, "hs@denx.de" <hs@denx.de>,
        "mikedunn@newsguy.com" <mikedunn@newsguy.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 11 Oct 2012 12:57:49 +0300
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B7041EF679@DFLE12.ent.ti.com>
References: <1347899860-24358-1-git-send-email-m-karicheri2@ti.com>
	 <1347899860-24358-2-git-send-email-m-karicheri2@ti.com>
	 <3E54258959B69E4282D79E01AB1F32B7041EF679@DFLE12.ent.ti.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bBkQa88hRk+GYciQwP94"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bBkQa88hRk+GYciQwP94
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 16:10 +0000, Karicheri, Muralidharan wrote:
> >> -----Original Message-----
> >> From: Karicheri, Muralidharan
> >> Sent: Monday, September 17, 2012 12:38 PM
> >> To: dwmw2@infradead.org; artem.bityutskiy@linux.intel.com; hs@denx.de;
> >> mikedunn@newsguy.com; linux-mtd@lists.infradead.org; linux-kernel@vger=
.kernel.org;
> >> davinci-linux-open-source@linux.davincidsp.com; linux-arm-kernel@lists=
.infradead.org
> >> Cc: Karicheri, Muralidharan
> >> Subject: [PATCH 1/1] mtd:nand:clk: preparation for switch to common cl=
ock framework

I do not see this patch in my mailbox. Can you please re-send with all
the acks?

--=20
Best Regards,
Artem Bityutskiy

--=-bBkQa88hRk+GYciQwP94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQdpgdAAoJECmIfjd9wqK02IIQAKIEmII6ZElSn7BBT2jk1Egh
QL2Nc/508Q99Lh8RhxaOFKN/w7687pGMlKCoeNLaF1PfUD2R9kJCIps3XxDZq4rA
FTuUNrurbKtE/d0JupAKJ4UB5nS5oaAjt+pmzYL/Y6cPyqH0r4wH3feCL8u4gsO1
cc765hCLxXE1vVQC7JJ0ca+8KrkXzt9i2nyhGRnNVT0Qx3PnGKfUzNiOX5RpSrhy
eiJqQ+YfbBFfTrQ0M1DfDmcTwWbK0iK4AX1bgZzI0+9fZ4t7A6g49Tl00AvRh4df
KRmhVh1ivmHd4pZvKrAQC25+3CgQKQLcE591WSrw6gVDcoKy4CmV7jpeKWu8B+Bg
mDQLwoqF63iplAN0Gi7NGGrTmgivUaAcAHOm71wTWkUy1bfT6HU0bW8ANE1wmZHH
rIoLJ5n9kZlKWNpUN/hKxZ0MeRThd+6vbTVaOZMxiLlm1BsL7+lzlyyae6H9LUfQ
DE7VoYq2RsQZQ0imN1OBZ6MS7Q8MwKppIYg+tB4L7JbGVEbX+xvPDz72lidVb7eu
0mrEIdKvAX6jg2GXbvFd5KhwKfTM6a79xpHbJcXcuGnchs2KOCo7hEaeUlFDNWTf
yx+31PM0mzwcBxGEDpQH0kB/MWsGyF58Clj06IijG0YwUJ4tqUgmpcK2v+I4UwAA
hgY/qy2uSqYsNXLGJK6H
=oBxH
-----END PGP SIGNATURE-----

--=-bBkQa88hRk+GYciQwP94--

