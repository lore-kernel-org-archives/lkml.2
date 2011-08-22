Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab1HVNFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:05:47 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:36919 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751506Ab1HVNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:05:45 -0400
Date: Mon, 22 Aug 2011 16:05:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH v3] usb: musb: ux500: optimize DMA callback routine
Message-ID: <20110822130538.GN30398@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313571820-5777-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dPW7zu3hTOhZvCDO"
Content-Disposition: inline
In-Reply-To: <1313571820-5777-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dPW7zu3hTOhZvCDO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 17, 2011 at 11:03:40AM +0200, Per Forlin wrote:
> From: Per Forlin <per.forlin@linaro.org>
>=20
> Skip the use of work queue and call musb_dma_completion() directly from
> DMA callback context.
>=20
> Here follows measurements on a Snowball board with ondemand governor acti=
ve.
>=20
> Performance using work queue:
> (105 MB) copied, 6.23758 s, 16.8 MB/s
> (105 MB) copied, 5.7151 s, 18.3 MB/s
> (105 MB) copied, 5.83583 s, 18.0 MB/s
> (105 MB) copied, 5.93611 s, 17.7 MB/s
>=20
> Performance without work queue
> (105 MB) copied, 5.62173 s, 18.7 MB/s
> (105 MB) copied, 5.61811 s, 18.7 MB/s
> (105 MB) copied, 5.57817 s, 18.8 MB/s
> (105 MB) copied, 5.58549 s, 18.8 MB/s
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

thanks a lot :-) applied.

--=20
balbi

--dPW7zu3hTOhZvCDO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUlQiAAoJEAv8Txj19kN11tUH/iY/03udh1mEDuNGlWsuTik0
AjqeEcKZ131i3T383ABXCAEVcrHBelVRIKGMNatfRn72MmZjPSN4+9Ji5/riUkDw
aVYPJusTLJXx8G91+1bJmOI1uOMoMzAnhDdWyfPe8P6XNMaLcfMcvFL6RS+8MXLG
q1ye5rIX4mh6mu1+Zemk1+w0XtKcyVRmQ/1ecrLyVYf9KhjP4TC3d2DYEljbG0tJ
hkfBe/b82x3/TyaLHu3Y75/P9V5l0EY6pCdYpZn9iQEr/S57Jc3Qdn49sMJ6dg8b
irlDX6LN+c5W9+NfaR8SI2ojC8VRiyRNipVmhs8+TsCHpPX2WGFYENupiPRYCxU=
=xEQM
-----END PGP SIGNATURE-----

--dPW7zu3hTOhZvCDO--
