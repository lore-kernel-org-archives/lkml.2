Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2BBMlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:41:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36207 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab2BBMlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:41:14 -0500
Date: Thu, 2 Feb 2012 12:41:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 6/7] OMAP: omap4panda: Add fixed regulator for twl6040 needs
Message-ID: <20120202124112.GG7428@opensource.wolfsonmicro.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
 <1328185019-29575-7-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5UGlQXeG3ziZS81+"
Content-Disposition: inline
In-Reply-To: <1328185019-29575-7-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5UGlQXeG3ziZS81+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 02, 2012 at 02:16:58PM +0200, Peter Ujfalusi wrote:
> The twl6040 VIO power is connected to SMPS V1V8, the
> V2V1 power is coming from SMPS V2V1 of twl6030.
> These are fixed, always on regulators.
> Create fixed voltage regulators for these supplies.

Same issue as previously, shouldn't the PMIC create the regulators?

--5UGlQXeG3ziZS81+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKoRhAAoJEBus8iNuMP3drgEP/3H7Cx6Ymsi+NQUG2Ku0d/tq
MVkeUHFvc3QInl1DQHI/qMp8dJSnQBgPr+95cmRbh9Yfv/6RD//b/i3VAZJ4sWOx
9p6UEyT784IWYk5lXiXh/wQOC/eqCLFKVhg39jmbjkGA+nhDQgoUhHRjn9GLE4iV
wb19mj/QZEN4HhCfDiJF6TJur2YnjIldKJDw66WJ06V9eLfrTs/jw0MGYFAHTomj
FerFax0nPlSj6f0P0WrSoJ1kIRxdJT6GZksqYCAyZZHTTtKmZdYkTsxrsnYsKnWN
L4Jk+JlgvuzGbB5cCJCL8s4+h5SWbJaebtXIXCLyKPjBwWU+/0t7JRLTjPLyn9+8
kJYhliTHX0r1CfTXbXHocTLp3YOQOfQGdWeXbzIif/XplgpzESuITC0EjC+K7/SG
84XtTFSS5bX4PAIxxtVESMW4+mUQmYueoRpYqorBhD2w6EbfwWUqEWe7VnnYgD+a
9lIp5FLkW7PYzyEKhNSdYUOwaOAoYM/5+fY8hE7yBwb088GrSPTCwQSyF5TAgk42
sVF6wI7LiEp4xa6jrdxTQN4qL+PYpLH87hytS+ixtna0Mae0ehYKn/ZBq8L5PzF/
u8/u7gdgQ3iSWbQgrEY+nJwnk1chQZKHBUFTNGVxKLE3D+/kF/S84x7eUvUz5JxU
/ljzWMAUHDy20A9ecaMD
=eIkI
-----END PGP SIGNATURE-----

--5UGlQXeG3ziZS81+--
