Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030907Ab2CFT7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:59:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41630 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030369Ab2CFT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:59:39 -0500
Date: Tue, 6 Mar 2012 19:59:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, lrg <lrg@ti.com>
Subject: Re: Query about regmap SPI
Message-ID: <20120306195936.GZ19635@opensource.wolfsonmicro.com>
References: <1331045140.32512.7.camel@matrix>
 <1331046532.32512.35.camel@matrix>
 <20120306163012.GW19635@opensource.wolfsonmicro.com>
 <1331055252.2453.8.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m3EZO/+NOdcYnaJL"
Content-Disposition: inline
In-Reply-To: <1331055252.2453.8.camel@matrix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m3EZO/+NOdcYnaJL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 06, 2012 at 11:04:12PM +0530, Ashish Chavan wrote:

> place to put this. BTW do you have any recommendation in terms of a good
> way to achieve this. e.g. will it be useful and generic enough if we
> introduce two more fields like read/write_flag_mask to indicate shifting
> and use those fields before applying read/write_flag_masks?

That sounds like a sensible approach.

--m3EZO/+NOdcYnaJL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVmyBAAoJEBus8iNuMP3dcNYP/Ru+bZumIb7/gvUKj/lCMZyE
YU3Bsmyupb7ooXkS5ezRSqn4sPVoqNMSTMn/ntsem+F6/OdKkJ0ahhtQX2quGLEp
TSYJBfrAJekSlSP2Sg3gVCD/j0waZwbe1JRizttKvKBOb5EdAMHrNLhVLe/dJH80
azyeqWZCVo+HKctvvugRqQureAXbh/1sm4nqVppwX0M/xAblpfX/MsQ/49+GP/dj
Q34/99uxyGXLE08v0n9g6xHVOv7vQxtS15apvaBi8jDf6yaHaAcMQYcwkyRVHieS
xFfuNjfNzz0BjSI+tzj3SuFjCdG6kYSfYef20DNPbTP9f+M/tgDikYNkWABeMVI4
bJvm1/lxuVnsqvQU4a+TJDiSc5Wz/zuFGv/aIoi5vRQyuE3q6ROEEHst7fgZdnyE
9Ae0iid+iWyt48T0NiU8E3ZyNiNbXv0K4S5JW/nTasdWcf4oY0gInjqsTVCEctab
utCD3ZU7yqJncQETjPwgTLeFTqB0QgYY/4E18XQHH8stSZvJHVoH1y4hhRftit4X
9riAzHHsp/pHY/l0LdndocdLPOJ3DCXCb0hX4NFJyg+jx0VL32MajCrSCB4IvaXi
08Or8BUenq4dTrj3XSB2h2dKAZ3wujeFJeoT/8TkqJziUJRmC8P86gqziFGzIyu8
sHst2UwUDRzlY5ntT49x
=WOWY
-----END PGP SIGNATURE-----

--m3EZO/+NOdcYnaJL--
