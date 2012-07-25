Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2GYLLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:11:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45847 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab2GYLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:11:08 -0400
Date: Wed, 25 Jul 2012 12:11:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Implement button detection support
Message-ID: <20120725111105.GI3099@opensource.wolfsonmicro.com>
References: <1342800449-10328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <500F8DB4.30401@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MFZs98Tklfu0WsCO"
Content-Disposition: inline
In-Reply-To: <500F8DB4.30401@samsung.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MFZs98Tklfu0WsCO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 25, 2012 at 03:09:56PM +0900, Chanwoo Choi wrote:
> On 07/21/2012 01:07 AM, Mark Brown wrote:

Please delete irrelevant context from your replies, it makes it much
easier to find what you're saying.

> Why do you should report released event to all of buttons? I think that
> you should only
> report released event to previous pressed button. If user press two
> button on the headset
> at the same time and then user release only one button with pressed
> another button, extcon-arizona driver have to report released event to
> previous pressed button except for still pressed another button.

The input API already supresses duplicate reports, they won't be
propagated to userspace, so there's no point in duplicating the work
to remember what buttons are pressed in individual drivers.  Userspace
will only see events reported that refect changes in state.

--MFZs98Tklfu0WsCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQD9QsAAoJEBus8iNuMP3d8LIP/itAiuBxD5FN4VvxCXa2SdNa
BxNRcTPhq/Qpb2R6LWgmEKphbjTYpPAVcQySR/iCuv3bJ+T8dwlzELVRIxmi+ujO
E41v174fPoxDnB0zskxBgyUxe4Da6AnVw/Y61AGXURapBXJb//rebIZV10XpXN2X
L2sm6bM/WzUb7/geEBizMO4cP2mHRxMN0qy58RVDMgqxSydOSn2Ylfny6Oo7/JdE
0cMuHflz1p7RxrY8BNqZ/eicjqdZd/yW8e/GXP23MlW4bLCDZZ8fAE/0XViSuGLX
sv5knFwmm1ubuzfVpKqaU18tCpgR7z6NaSdkOdqg0hZhM3JPG61g50PAU5CXU5R3
nMQU9OwtElClbdGW7vL4ek/qHki+33rca4AYFskKrPvMSYZ7x317wjww7yqcuGPB
1+w01PsHPcOwMHaUKisEpNLrngw0Opp+AUY/5nV+3l9aQ6uJs3ZojV4aFGxnOi4n
vC2zZRPGBVnay0D4F2SjZyTXVweCZuBECZGEvql6SUA8vr3JIxP5nyluZZMIWSTy
jiuzpU/jdHGNTvPWRTW7WbTOql1s6H/MFhGb0LPZrwmWWUPxVqqoehKSX5VY7kEE
01MuM+LytvGLpq6YRxqjd836By5WznfgLc6VeNfIV+5YE+z3PSfRMGn5HljnjcIq
BTQwol66JfujINnUcOaT
=j0GV
-----END PGP SIGNATURE-----

--MFZs98Tklfu0WsCO--
