Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2GVSuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 14:50:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51290 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347Ab2GVSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 14:50:23 -0400
Message-ID: <1342983002.5132.53.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 00/11] 3.2-stable: Fix for leapsecond caused
 hrtimer/futex issue
From: Ben Hutchings <ben@decadent.org.uk>
To: John Stultz <johnstul@us.ibm.com>
Cc: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jul 2012 19:50:02 +0100
In-Reply-To: <1342508724-14527-1-git-send-email-johnstul@us.ibm.com>
References: <1342508724-14527-1-git-send-email-johnstul@us.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HfMN8hpao98Ey66GUrD+"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HfMN8hpao98Ey66GUrD+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-17 at 03:05 -0400, John Stultz wrote:
> Here is backport of the leapsecond fixes to 3.2-stable. These are less
> straight forward, and should get closer review.
[...]

All queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-HfMN8hpao98Ey66GUrD+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUAxLWue/yOyVhhEJAQpfog//ebDGnETYIT1W+0/3Kp2U3Gv1zACLQmRJ
tv5VRAP1M6+He3RaBgstsrh8sOgKqQnlqWhU4IltPZxEsyMSCcx04Jr3iZ6/0/iR
+7Md7YLsWcCY5e1Qjkgg3lwTye7y/gFcT7fVeCsx8UAWsmkdUCbMSK0ARS/ZVrLM
ENfkA8L69GoIq/0q7YXG0ptii6+l9jZl9zL3KaKmzrGe0t8pdyb+VT5Di0oHOC/5
7G7nfU0MMAEu51/h88EUoQUfibvU6vqvR22hRJRCS1zFdXMbiy0w3Pj6A6jnyM63
KQsNL40CIRxGxatdHCcmURXS/2gm5kxnG7+U9dotwDY95LHgOmPVIFp8OMETAMkt
N/aD80l9pNHVfsxMqgnZbOw7VaobzuoGUJh1BbVMfU8XsE/tsuRHEc+1LuuhRMoY
xy+MsPoVxkrdCJMzevHLC/vxLnN5ri/UG2AoVNO5yCcX0qjgsgC5OfELed7AnwVe
E1F4fH2T2RKJCWbLuFdC30Afia8zNXlD3P9PLhswEXHdbgnCaJ4OOonsuKo/qL0c
CQhiH97Gi4RqSXB4RB1zuOCGjJ/APG7xCSzQMW6wZfapnYNPheOolgNQ159M3mDI
7m8U6ZAqVD3L5P3NyUMabs/0l2fHpzd8iTjnm2d/WGlS/iCaJNa4HX9XEXskERe1
LAptglG5eXs=
=G4Zh
-----END PGP SIGNATURE-----

--=-HfMN8hpao98Ey66GUrD+--
