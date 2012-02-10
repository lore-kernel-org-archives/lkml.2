Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab2BJLYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:24:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60771 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754935Ab2BJLYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:24:44 -0500
Date: Fri, 10 Feb 2012 11:24:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] regulator: twl-regulator: Add fixed LDO for V1V8,
 V2V1 supply
Message-ID: <20120210112441.GE3056@opensource.wolfsonmicro.com>
References: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
 <1328868316-24749-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <1328868316-24749-3-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 10, 2012 at 12:05:11PM +0200, Peter Ujfalusi wrote:
> V1V8 supply most common use is to provide VIO for the system.
> V2V1 supply is used on SDP4430/PandaBoards to provide 2.1V to
> twl6040, and also as an input to VCXIO_IN, VDAC_IN of twl6030.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I'll not apply this as it'll cause runtime breakage if it goes via a
different path to the rest of the series.  If it's getting near to the
merge window and nothing is applied please remind me and this can go in
by itself.

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNP5lAAoJEBus8iNuMP3dergP/iz/r+K0OmzvviIzPqdS1nyq
Lrv+PY/ygeeWKX4y+sgktvBoegvxdSD//NMmmycyloIN7rtMZZp1/BU+sij0XnP8
MkNEBt7kamfGBKqqmc0TVTfqGs+ue3YWcY0qYbBV+XrCppLnI68sJT4MhXrP8slv
ekgDriV5XChMUWrQabu4q8WflMHksUiSZV9/nn2TNNSQgFfA1LvDtLrfojfbNAsi
NYLJAC25UR5eEhKFlt6lowrwjgf+8sqqznU+LBINts3llfz2U4IEp5AGStHBhx7w
ak32T+eOODNOrfgSJA4W/V/xQoowXd4FM+t1AM+ZTzy1J2M+8/01g61rkNrdIuVR
cjtrDH+c6SV/f3ArE/WvBZqQSl/MBUfikzOmWJbyhLbWf+0WNitC9+MwAeoF4azE
pqWYv26mmwtWZPFJMxmea2XOoOQlnxN9oyepmeIVpMZTb4WYkT6LOG5nCreATUbf
kJCnRapSBy1gjjq/hNOoYNEAMFT0vvMgyHQ3BpHsB+rJeVPUAO8z5g8ByqSkDy2p
udQQigzalzcGfJvTZyYxQR8r5M9o8ttecoV0czHwyk+yLUQUMhnqoW7GJqhl0VJr
u9W/zj8b7cSo2zkK2aYdl5eAiueoEWcmDtNeX8NKOCEUqJ13UiG0wwCLRBfjX30U
PnS4VUwY/dEWW3HTPplm
=p0i3
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
