Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2LJOpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:45:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:6598 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab2LJOpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:45:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,252,1355126400"; 
   d="asc'?scan'208";a="255183861"
Message-ID: <1355150780.2657.36.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/2] mtd: mxc_nand: reorder part_probes to let cmdline
 override other sources
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-mtd@lists.infradead.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 10 Dec 2012 16:46:20 +0200
In-Reply-To: <1354779748-28869-2-git-send-email-LW@KARO-electronics.de>
References: <1354779748-28869-1-git-send-email-LW@KARO-electronics.de>
	 <1354779748-28869-2-git-send-email-LW@KARO-electronics.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-iWjINyuuJtmvfRMyGK93"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iWjINyuuJtmvfRMyGK93
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-06 at 08:42 +0100, Lothar Wa=C3=9Fmann wrote:
> The cmdline is the easiest to change source of information. Thus
> let it take precedence over 'RedBoot' and 'ofpart'. This makes the
> mxc_nand driver to be in sync with all other NAND drivers that support
> 'cmdlinepart' partition parsing.

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-iWjINyuuJtmvfRMyGK93
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQxfW8AAoJECmIfjd9wqK0W0oP/2gUTNszHHIboFKEuJT/UuDM
3PqsPBMuZk9istkPYrCF1n0tx6OQ07/Sz/UqrATl0iqfqWhlveTqvYVMza0mspJK
0hOMOSJKb4n78acyMv/d8E8GSkNv/5pewdEC6vIn6m+H/AhyFFNETcsxSl8SQC++
XQRtaBFWGgtM3OlzkLUKW2HQMFCAL6J7WmZundC8RspvxKa4ek726wDeY58wrMHU
jLymLdeomHf63pRaQUQiMin8XA6wUotXGJOTs3XdDhshkjCMl59/1UOwUVQ12ozf
4dc14R8mtuF3LoX0afsf82oRTXoJZue6bloiaTqKRfcH5Tg1ZFxrfTRvIXrXAjf1
uzLKLy1eZwIrLdquoT3Jl7F7IAu9D8Trxu4ImqchgFAKzFPJwCvU9OUFZPUEFQhF
6LjC+NglWYGFNJN0+AXPhNE2nE4RuypllvWcA3jf5YTrD7hKxjAadd1STa5+R7BU
Oko+UnOkYrTv74jqpiPNJFQgW2ZfEhndvJoSOuAp6Sjf5OsyOr3+BZNKkWHhiXTk
hqbPjbEiOLQlKOYp5V9Z1/XUh2fM0TsGZpTS0kgJehu1VBLoz+Ou42b63svbpovT
RP9shmoPEk9EfFB7eD/+LiRzLvqFjRJrRkcZTeEAK0PFxw6gEXpBD/+zg5ut4VM1
PpqqrNUBvox7xswyG6XU
=xRcY
-----END PGP SIGNATURE-----

--=-iWjINyuuJtmvfRMyGK93--

