Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2HPLza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:55:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:65336 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab2HPLz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="asc'?scan'208";a="202619832"
Message-ID: <1345118411.3393.219.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get
 bad_peb_limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 15:00:11 +0300
In-Reply-To: <CACQ1gAgqYPAWvpCs-buhZfoxDfvsKYge=pq+Xg0eGAuURbNjxw@mail.gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
	 <1345043331.3393.151.camel@sauron.fi.intel.com>
	 <CACQ1gAgqYPAWvpCs-buhZfoxDfvsKYge=pq+Xg0eGAuURbNjxw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Lytkzn62nGvs0gyuZXRz"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Lytkzn62nGvs0gyuZXRz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 10:13 +0200, Richard Genoud wrote:
> > +         To put it differently, if this value is 20, UBI will try
> to reserve
> > +         about 1.9% of physical eraseblocks for bad blocks
> handling. And that
> > +         will be 1.9% of eraseblocks on the entire NAND chip, not
> just the MTD
> > +         partition UBI attaches. This means that if you have, say,
> if a NAND
> I don't quite understand this sentence.
> Maybe you meant:
> This means that if you have, say, a NAND flash chip that admits a
> maximum of 40 bad eraseblocks [...]
> (but I'm not a native english speaker !)

Fixed, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Lytkzn62nGvs0gyuZXRz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLODLAAoJECmIfjd9wqK0gwIP+gJa70MK4NH6mvMuRfAcB0pm
b4PUW7iY3hYnfQFRUru0VH0ObYVMhlYM8z+yK0whe0CwA+5J7C6/pVfPy4QCV4Kf
1o2OZU1IWczkBcmiSy3TRI2/Ep1wIVMiKVkgCvJJCm9Zl155AGz61axSL3aKv9AG
J+KHT2Kktmlo+zjxUNbXk8s+vAyydtfphq6Q/g3629ELAO05P4zpDllPRJK5njQO
G4fiEbKvNy5I6xc+l3zBUld/eYCz88Ybq0GuasHVdyXWiViDbQUfcPnCqZimmUVn
Uy+1QOozjSjj+56NbzntrkR8sWNv1wO8Mibku8Wqy+N3N6/iMvcxaB/flSI6+/B3
W1Ga0fXN1wJ/tQUhtl8YMiCUxxBNOX1axU0wulB/BuKW1RWdowMwaPliXHnISvjx
ck2IRDHbkatL3Z3MNgWmmDrxi240HxIhfEnriNFS7tW6LRz99B2CDtrbscfCFH9T
+86G50ivGknxRFIdpQLJI0rFias3u8z9Blag443KGsBXFFaSK14t+HNynWGxTl/E
0CiRpUxjt/KxU/GQilMsAIu2R7LX+4+3+oAD1OHMhvjG6r9XSvBQMX53mSYVEcU7
nUWTUco05eDv9JWWkSwR+bST82/zgs4IOzlcx2N11RBk49oAl60NoXPm/c25K1qa
TVBsg7bcuH2dsbL1sokJ
=GEmn
-----END PGP SIGNATURE-----

--=-Lytkzn62nGvs0gyuZXRz--

