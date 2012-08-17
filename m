Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2HQHab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:30:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:40970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab2HQHaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:30:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="asc'?scan'208";a="209707572"
Message-ID: <1345188896.27859.4.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space
 parameter
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Fri, 17 Aug 2012 10:34:56 +0300
In-Reply-To: <CACQ1gAhRYSYehym1qA_Oj71KU4fB2+1MEUGi5Wfnb+E=t3jcxA@mail.gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
	 <20120816115713.726da8f2@pixies.home.jungo.com>
	 <1345123718.3393.235.camel@sauron.fi.intel.com>
	 <20120816165027.6520c4f4@pixies.home.jungo.com>
	 <CACQ1gAhRYSYehym1qA_Oj71KU4fB2+1MEUGi5Wfnb+E=t3jcxA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NkLWXl0n8sfCP++pTx84"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NkLWXl0n8sfCP++pTx84
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 16:30 +0200, Richard Genoud wrote:
> > (there's one platform known to do so in its defconfig, that's
> > sam9_l9260_defconfig, which uses 3% instead of the "standard" 2%).
> I found the board:
> https://www.olimex.com/dev/sam9-L9260.html
> and the nand datasheet:
> http://www.rockbox.org/wiki/pub/Main/LyrePrototype/K9xxG08UXM.pdf
> page 11, we can see that the max_bad_bebper1024 is 25 (100 for 4096)

OK, thanks for the research!

--=20
Best Regards,
Artem Bityutskiy

--=-NkLWXl0n8sfCP++pTx84
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLfQgAAoJECmIfjd9wqK0k0sP/2f50N4v+cRPDIM8lvIsqZrD
Dx3YZMzhp8QrBLeky3XvaVNwfj6r702duhhbIHUpBrhCoTQ5q5czZogw6s3qLlt1
ji2aG+j/psO8LtW8iMe3xvdmaQdNPGwLmDf0sWnpX8Pjn9/wDr9aTMervYiyjVsU
7qEpdB2SXICGf1U8BvSY+ITHmtmgUG/L60g5y1xgKIGrDC1xo4RBy3/JN+/IXOZP
zjuYH13aD3WwuBthyHRSvJWOOzmNBTPI6v7CszmXqzjZPzbfaAXPvu8FBuwtucVb
XcJCu+Dp7VMYzMwedEFe1RCoTaUMc+4FUPgJ4FSMPHWqrrBxSdKSSd+aCE0v/r/b
6GDOHgMMXvEu7pBHd5d0gnhL6wniIl1egZSTMN/MvngZCF6lJefYmvop9U2w6Ofp
sHMJauJC7vguOSroZaoGX3TO4sKncbmQfQssJeAchM4Y6dXD0Hbdi5soBm1N/yJR
K4OyymmIlyTm8wZ0Wtip6nvSJ2q4F7XyiN4Fu5wdX/9lvo5h/KBZLoJ91lYeg4+h
bfXh9aFwne8xErLm8QoFkkWbu56VTvoO0fTXouFOxmeDm3fpm4Ozl4lSkwbSXzLo
C1RbvxJyqMPoW86Dd9Tm5NhFee725kMFFP8syzDDZ+I6lOMUbitIQMjQ3GAhJKNH
p4D0qfEoHoEojm7sl1wz
=AH0o
-----END PGP SIGNATURE-----

--=-NkLWXl0n8sfCP++pTx84--

