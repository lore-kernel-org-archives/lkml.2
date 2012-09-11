Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2IKOpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:45:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:51340 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759218Ab2IKOpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:45:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,405,1344236400"; 
   d="asc'?scan'208";a="220581792"
Message-ID: <1347375033.27206.3.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] clk: Make the managed clk functions generically
 available
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, Greg Ungerer <gerg@uclinux.org>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 11 Sep 2012 17:50:33 +0300
In-Reply-To: <504F4E36.20309@metafoo.de>
References: <1347202862-1617-1-git-send-email-lars@metafoo.de>
	 <20120909235059.GA2643@sirena.org.uk>
	 <20120910001524.GL13739@n2100.arm.linux.org.uk>
	 <20120910002020.GB16249@opensource.wolfsonmicro.com>
	 <20120910003913.GM13739@n2100.arm.linux.org.uk> <504F4E36.20309@metafoo.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ORrlNyB7sRZwoa6Haco0"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ORrlNyB7sRZwoa6Haco0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-11 at 16:44 +0200, Lars-Peter Clausen wrote:
> On 09/10/2012 02:39 AM, Russell King - ARM Linux wrote:
> > On Mon, Sep 10, 2012 at 08:20:21AM +0800, Mark Brown wrote:
> >>[...]
> >> OK, that's what I'd thought was going on - it was the fact that you'd
> >> just acked the patch rather than asked for it to go to the patch track=
er
> >> or something which made me wonder if things had changed.
> >=20
> > I kind'a forgot because it's been soo long since I took any of those
> > patches...
>=20
> Ok, what's the plan? Should I add this patch to the patch tracker?

I'd propose to send it to Linus for v3.6 even.

--=20
Best Regards,
Artem Bityutskiy

--=-ORrlNyB7sRZwoa6Haco0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQT0+5AAoJECmIfjd9wqK0pKAP/jnlYSNmRe+U8cQ3SOX5J9aT
8qgFocrAEGpN0fHRf5zd58XkLKH1uYTJ0HloDooNaFqICUiprxkY9FEwHPUo6Ajl
MeZ2DYgYwX6/VsGxVLCg4uj+mqvZw+n1U6kUKKjCRim+DQEXejpwn4xMVk1QlOse
GZFt4Cll6w722cxITfy/ni20KR/cwz0i0YIjHTVtXBL3ge2KJgcSYcrSPJEv3TAp
Wj9FJzyq/wB315u4VraD93kojAGNVWzjisj/ICsrLtMzz/Vi1sIDeqNG7P/eOL60
jAVh9Mv11mspIFWd8IUChBSSbZ7y1nWOcHa6bQnZVtemee/VVWqz9Jkttqt1nJN3
7Q3bNc1gKvgpL0OyiXK8RYeMvXYl+l2tJOJX0mX6lgwyL8Onlf/M6TPcQfn7P2Mt
lnPGBskut4pw+RxwbRy1LuvIeLghcHJjl1b7Clzar4pfii9cRmvPIoC0A0ukSuOA
S7jHs/Ohobm5+jFIj7/rFxQGPLhQL/90jc/m6jXDadEJYVzxw0/ZDjJyezAUVea2
MgYdouGTEIolqDDGfikNzH7immJ4MfhvVxcWkkb1ZYnU4df9zWTV5iwRpmP24S7g
T5Kirx7ETkMOirtCKjolA8nCUkVAoBnIfbRFhFldj6gzjYrSSEsJNE3ENq/hbR3g
MJpGgdtLGGCoWD85wmLZ
=aqAW
-----END PGP SIGNATURE-----

--=-ORrlNyB7sRZwoa6Haco0--

