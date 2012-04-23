Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2DWXSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:18:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:38034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab2DWXSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:18:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="145046762"
Message-ID: <1335223119.2783.13.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH 2/2] e1000e: Remove special case for
 82573/82574 ASPM L1 disablement
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Chris Boot <bootc@bootc.net>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        nix@esperi.org.uk, linux-kernel@vger.kernel.org
Date: Mon, 23 Apr 2012 16:18:39 -0700
In-Reply-To: <1335216578-21542-3-git-send-email-bootc@bootc.net>
References: <1335216578-21542-1-git-send-email-bootc@bootc.net>
	 <1335216578-21542-3-git-send-email-bootc@bootc.net>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-12bCDlL8Kf2mXAWXMILL"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-12bCDlL8Kf2mXAWXMILL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-23 at 22:29 +0100, Chris Boot wrote:
> For the 82573, ASPM L1 gets disabled wholesale so this special-case
> code
> is not required. For the 82574 the previous patch does the same as for
> the 82573, disabling L1 on the adapter. Thus, this code is no longer
> required and can be removed.
>=20
> Signed-off-by: Chris Boot <bootc@bootc.net>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c |    8 --------
>  1 file changed, 8 deletions(-)=20

I have added the patch to my queue, thanks Chris!

--=-12bCDlL8Kf2mXAWXMILL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJPleNPAAoJEOVv75VaS+3Od3MP/2/zlsipy1dwhS4+fRgXs7VI
B0Ja9znrcKBqOsrJ9gGCXKYt15NDN8O320E0xupdkgBQF/A0V2nl8EUiIqyilGVd
mcrQ2RFIOeTPexhLy83VCeZ+4HMc8s6+mHFLhrcuWNU/oAEgRNYXmW3/slT/p3dj
1VhEcTD8PqiWXrklgncgbi43sry++SyKxdoRfNkjzh9CPcmAupHKcRMSc+Kc45Rl
sHl2m+FUz7H4Qzs1Kwh5FiKkvPzH6IRpXFbn4wMlUAwSfjE0LALNFKu8zRcrrfv7
PrLZGo7S9uUIKUe15Ts71pbN6XSQ/n3F5zZdUk1Eq1adDBd3LzrJFjxZMMwZ85py
SkV/rjU3zGkGyd9nZmZ4nkiu82G1uHAx5WUGg9ehXJAm7EPY321T/mRrsQ0M5+Ql
PEKfj3qwVZMv9yfI9Xd1pmZ9cIievHdyJDYXP1UuFrL6ohQ8CjhvdKVo61ffGWna
4cWLs2lMIeDpyWwu/JtIFOcv/jKtTC8y0Uy5JEfbLIO+2dJz09HdsjtoBjBUcaOe
VPwOsFgpqLzHlJxAz4JGlTfsweDceqs2uV1G5CkFYYjqEb/YrqfE3ldsbDXgK2vn
IB+zklqMW+lGhR8bzo5SwgDptHyDw4fB0VATlCKZyIQJx+IsQhlcqPWuDo9/pHU/
oG4b953YmIwn5CqLyg28
=E2gW
-----END PGP SIGNATURE-----

--=-12bCDlL8Kf2mXAWXMILL--

