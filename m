Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2CXJNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 05:13:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:56865 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab2CXJNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:13:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="132673757"
Message-ID: <1332580422.2797.11.camel@jtkirshe-mobl>
Subject: Re: [PATCH] e1000e: clear REQ and GNT in EECD (82571 && 82572)
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Richard Alpe <richard.alpe@ericsson.com>
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, peter.p.waskiewicz.jr@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 24 Mar 2012 02:13:42 -0700
In-Reply-To: <1332507320-19902-1-git-send-email-richard.alpe@ericsson.com>
References: <1332507320-19902-1-git-send-email-richard.alpe@ericsson.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cGg+KLM7f9NBCFSV1rxu"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cGg+KLM7f9NBCFSV1rxu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-23 at 13:55 +0100, Richard Alpe wrote:
> Clear the REQ and GNT bit in the eeprom control register (EECD).
> This is required if the eeprom is to be accessed with auto read
> EERD register.
>=20
> After a cold reset this doesn't matter but if PBIST MAC test was
> executed before booting, the register was left in a dirty state
> (the 2 bits where set), which caused the read operation to time out
> and returning 0.
>=20
> Reference (page 312):
> http://download.intel.com/design/network/manuals/316080.pdf
>=20
> Reported-by: Aleksandar Igic <aleksandar.igic@dektech.com.au>
> Signed-off-by: Richard Alpe <richard.alpe@ericsson.com>
> ---
>  drivers/net/ethernet/intel/e1000e/82571.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)=20

Thank you, I will add the patch to my queue.

--=-cGg+KLM7f9NBCFSV1rxu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJPbZBGAAoJEOVv75VaS+3OPT8P/jHCq54RgnpKLcrUBgajBw1X
RuO2GUELzReIELGMaM9Fp5zVKszSslmKxp5nMVqH+OzN2MsMUiz8wS52QLtVo1Lf
WwhGJeN8SKlRNnEFkHR7qYA2QxV+0MlIecYypcA+F9GRaXt/qnsXkEcvTyoVk8iJ
jlEquwbzeQzvuB/Y4EhNIKTG8CyXME6tr2OOo0x19axUnozINXZdUxEX9I5K6IxN
ySkZ3TSjWr5bBCjeeHZ5/ExPyC923dqE84iJ1HF1MYZL2v18fHpratkCVLr96g1E
s/PGHEltFAGbWTOv/iGJBspK2mBTziBk9rLaBiNg0k8sLeA8dHnc0eH8EXw6aExF
MyAx4Sqx7y1o1TZpxNzJMTlXdbqn3ORiFYfSsUXTzuXOKw5a1P6VYukNh+Eom++Z
TuMD4O2TNu0ncyi8ygGiJI0uIMRMrd6zxNLLnrYK5AA8yDmNjlgqwqnboPbhCUc2
A7PK2FS58BC7KZ2jBZNSnM+MS7fKC/Bv5SqV59Dd+7CAQ8TI0UnM399AmQCBLnT9
7JRkJAnT/GK6oOhoKrI9Ceyy2ZBF94lm8Dkd0Yt2YoVxyLUMpFEY6+1Ctv1sQ0sz
ZEFgh9BVoorO/OvLglUDpCwos1fX9dtatSVdib+8a6MYOzIHrYI5mdacthF4iAUp
3l9C8vUiAYuvdn691o+9
=LfMq
-----END PGP SIGNATURE-----

--=-cGg+KLM7f9NBCFSV1rxu--

