Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2IXOiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:38:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:45217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab2IXOgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:36:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="asc'?scan'208";a="225774692"
Message-ID: <1348497378.4880.59.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd:nand:clk: preparation for switch to common clock
 framework
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 24 Sep 2012 17:36:18 +0300
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B7041B6EDA@DFLE12.ent.ti.com>
References: <1346350624-27291-1-git-send-email-m-karicheri2@ti.com>
	 <3E54258959B69E4282D79E01AB1F32B7041B6EDA@DFLE12.ent.ti.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-nO7x8rB4kMA7BG3DUB/z"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nO7x8rB4kMA7BG3DUB/z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-07 at 18:39 +0000, Karicheri, Muralidharan wrote:
> subsystem owner,
>=20
> Could you please review and apply this patch as needed? We need to get
> this upstream before submitting the patch for Common clock framework
> support for mach-davinci. If I need to follow a specific procedure to
> get this merged, please direct me to a process page.

Pushed to l2-mtd.git, thanks!

Artem.

--=-nO7x8rB4kMA7BG3DUB/z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQYG/iAAoJECmIfjd9wqK0sYMP/3qOWC2uFuqrfcqLsZMIfE8I
mgccDRnG87zUg2TRFrcYh0VUOxH3QSHGO2dg29kcThqmx6O3JpLrTPxq6/KQf+4f
1l9dbXpbJ6x2z/OtpuXNFYVTQ9tqaoe1Y7e6X6PLoSoS62UZ6VNks4qMQUvf9fDa
1rprzzvssPwwRggfqtAfhlqyWuFxqyARnC3cuLZhNPFDkqEB1TZ5lSEzn/p31cbd
ZCzcJI18avGRhCn9rnRexUVXWVxXOZXuFfeyjBHD8IQDltarLspO2mDj29Pvjm1L
J9HxVB+A5Tbv2s2QPbQ1wAma88XRJ4ii1cQNhUV3232owJ7bLiaLQqjzHBZ/Yqcq
bIw5PkV86b/Z9CdPaE2A0gc+ED5/9Fi7oodhaPjO9K95uK9JrY7QLjpQqxed6oQ9
o6GGyvzQZlgALyliJCOxvMwjhPV7x/iHOt+kCk1zu+xaJvHvXnc25jTILuF0pYyx
Tj0gP0OeeYOF1sV+kF1s26yPntcKQRJQvR3Pz7sVabK10bC+lGY6Z+DBNGIVrbFD
azq/k7ga9AjAwprHNWH+/Bz1uT0y8VOfthNyHxgFnMZuhiCMdaRMfg1Fa+Q1B69F
Mpj882H0Jez5lZHyR16RRgdw2ncxHgxcO4m/MIgBWlC7tXfo8OP5zkw8L7hIkI7p
Dt7AWqUQRExVCsZQ+Jq+
=7Gfj
-----END PGP SIGNATURE-----

--=-nO7x8rB4kMA7BG3DUB/z--

