Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1KHOII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:08:08 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:37703 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932125Ab1KHOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:08:04 -0500
Date: Tue, 8 Nov 2011 16:07:58 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2 1/2] USB-musb: move to dma_transfer_direction
Message-ID: <20111108140756.GA20728@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318610350-23335-1-git-send-email-vinod.koul@linux.intel.com>
 <20111108140222.GT6921@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20111108140222.GT6921@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2011 at 04:02:25PM +0200, Felipe Balbi wrote:
> On Fri, Oct 14, 2011 at 10:09:09PM +0530, Vinod Koul wrote:
> > fixup usage of dma direction by introducing dma_transfer_direction,
> > this patch moves usb/musb driver to use new enum
> >=20
> > Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> applied, thanks

I replied too early, this breaks compilation. Please review both
patches, compile test them at least, and resend Ccing linux-usb and the
maintainers of musb (myself) and Renesas... to make it easier, run
scripts/get_maintainer.pl on both patches.

--=20
balbi

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuTe8AAoJEIaOsuA1yqREfw0P+QFic50/XHZdS2sT3XW1cIL+
84nAczXcdOhDp8isuRAyMOlrXc1gc39LRGIWpXKFYJ06wukBQtsnNMSnlgwz7lLQ
44y+jlIseNtkljKTsf0wleYTMp4Oq0x1snKx5bp/5ti6cma8/7CArMpdOLS2bSTm
oYQ22UW4cFQIGwA0tqnkByyRTCTZVlD2aQgwGC0oKAXXInYImclFOLYYscnypUkc
Z8/0E04POWnAxblxtxMft6gsto9al3g3v2enref1iNLif3gD95HPuTa7PSTLTmdc
7nNSDvBE9b+6KjeylCxtvKc3Dq4aHoF/sQnOtE6cghozi6VABXlXycnniHVAfxLu
HfE/l7zhhWgU0k3E9Sbt1l4daH420zgorv/wdaYtx+OkEyQD8l2oRxPp/PMTrtgD
+6uJHMcfSts77sJrmWzjvSDqkJ1yCH/1CV2JJ9Vr6muCPzu6/FOolMR1dR8Gd9DU
okfVXAQbtECCqaLN3H2B92wFZTIY1KTWDS94xrBWuxIMsqbSzXqtLK7242x8jFUG
zlkG1r0Rn7dsYgcZtAjXiZINegULgGg0VgONbMkwam3LoMYXS4jmPycSIlEzh6QP
lVmCai1LF3yh4nLbO1tE2tGEd/zYjXOj0vxmdilDE1aFsvee1u8pAeP0+bKZvFYP
R/EuVFiyKFAqGgLQi/zC
=WF4T
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
