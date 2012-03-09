Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2CIMdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:33:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40537 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074Ab2CIMdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:33:35 -0500
Date: Fri, 9 Mar 2012 12:33:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sbkim01@gmail.com
Subject: Re: [PATCH] regulator: Fix s5m8767_set_voltage_time_sel calculation
 value
Message-ID: <20120309123332.GP3273@opensource.wolfsonmicro.com>
References: <06a501ccfdc6$2ded4c60$89c7e520$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CKf/2jVYos1l2hij"
Content-Disposition: inline
In-Reply-To: <06a501ccfdc6$2ded4c60$89c7e520$@com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CKf/2jVYos1l2hij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 04:28:10PM +0900, Sangbeom Kim wrote:
> In the s5m8767_set_voltage_time_sel function, divisor unit is wrong.
> ramp_delay is usec unit. So 1000 should be multiplied.

Applied, thanks.

--CKf/2jVYos1l2hij
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWfh6AAoJEBus8iNuMP3dnCkP/3coVjy8YHER/NjJj4+mKAZs
CBnSllXJTgErL/ZUE6KorTDrHDow4Fj+hD2d6I0tksjVIWNrfrhl+/YR0iInI3IT
4nmKulYKeNa4RpLyHITdqA5YXgeebOf5sUbRERL6TNqwAXoDuZGGJOe3GaN70j1Z
qD7X5cUI4yk8slPJQ+msoYIr74SQA43Wlp4opXilGVOdlCc2LrEgCCuuZyomHXQt
iSvNglIh/BakW2R82MdeoEu5RSTL9hMmPScRzwI0Q0YLDfI9Faf2w2OVxJQaOXgy
WLmbLmPtiNcQKYSCTyfXlalks8miGIsYmPSRV6/EdyOI//mmEigx/ciscm2Iw9ND
xlChsj+yA50TNQqRjnyUGz7B2Jxu0TFbQtcqZKMc/AGt7XXvcnrK9HRSzSLN4caq
l1GJ6hwYx5qj+MqJP2vw5qduwHX5DDNkm0HqY5gNBdX6J+AlhbHUi99vaAkpeKnv
6bUrE03NXYIfcQDYjBDWB8gdahEDdtGBFNTVZ6njbFT1FIraGQjCl9l7sFrGx8LA
ubn7UcIHHpW+MI79ICUivNx9TKw0U+EvgAYbJjH52sACNZbOVWZji2UMrE45jVFK
i6pYMZ35Spp5AJ27PyRy02uDZ2x9lCE8p8oiaD2wInPFREC4bI18jsN/T59fJHpX
sZcG8KibChd2pvmeuDYt
=xuJ2
-----END PGP SIGNATURE-----

--CKf/2jVYos1l2hij--
