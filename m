Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2HOMs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:48:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:63614 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab2HOMs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:48:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,773,1336374000"; 
   d="asc'?scan'208";a="186708789"
Message-ID: <1345035219.3393.137.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get
 bad_peb_limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 15 Aug 2012 15:53:39 +0300
In-Reply-To: <CACQ1gAhMDQPOLhgi24Y8L_OFk35C1e5_1HchrRY3HFuA99+PMA@mail.gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
	 <1342594206.31927.7.camel@brekeke>
	 <CACQ1gAhMDQPOLhgi24Y8L_OFk35C1e5_1HchrRY3HFuA99+PMA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Y+dIiZFkzQjr35rsURVG"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y+dIiZFkzQjr35rsURVG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-18 at 10:30 +0200, Richard Genoud wrote:
> So the per1024 thing was really to stick to the device layout and to
> be easier for users (IMHO)

Convinced, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Y+dIiZFkzQjr35rsURVG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQK5vTAAoJECmIfjd9wqK0O+cP/051sHnxvd3vDLpXbmiyY41w
v03BP78a/dpY+polSpq94xYl0/cVvct/9JqxfSA/kQcAwCwX9RhQX98DSVGClMdd
RbRZX/+Pyg/q1MWHkkGnwhPsZRfNpmiuQ1sUrIW33MVZaQh6vfZxUUAGB5Hdj2Hj
TgZylJHaNvAiWFEW5vaHLqrycvcoqRMapwjxJyCLpfW2KV5IMDL1U5ZC9erAt4pX
PmAD1ljLhaClQyVKxAKJN02jJYOCArNLxvdJgidbRsT02QgNbjiIJ7dsazgyj0Oh
Nk5QvIJR6JIKBb11dBoB2foM3hUywhHWD58ecgzcvc8FI5lsqsr3scyUqWdZ0QY4
80UeP6+EmjycjjTjGEjrnOeyM//l3XoPL4vz1Lk517/zGn/pS2ElshqfqZtrhTHC
1PpcdLNvCbludlX8ceA/ZEdWYOVK10JeBsUundoTq+niVmqUokO8rfGFxqlBfY8c
WdD44QnFCvJygQy9KM1wXN7+YCyRY0U2MCpaN+A8MrGa7PIlJn7XuXe/hVNneg1O
DWmkwLTSA1LYQ2DpVqK1yaQsCpDbFWDXo7f9/4eWsBt/4PQcRsvGeKuT+k1SX/PM
QArmsPKvz9fTaRS/ZO7M+aQkuxPyNi2ZMciPPdlak68AWWDvMgA6/1Y6Ca8v69aP
Q1GSfByNvDxUKrvnXxSC
=54hx
-----END PGP SIGNATURE-----

--=-Y+dIiZFkzQjr35rsURVG--

