Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab2C3KOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:14:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40470 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759310Ab2C3KOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:14:18 -0400
Date: Fri, 30 Mar 2012 11:14:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: Erik Gilling <konkers@google.com>, Arnd Bergmann <arnd@arndb.de>,
        NeilBrown <neilb@suse.de>, gregkh@linuxfoundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mike Lockwood <lockwood@android.com>
Subject: Re: [PATCH v6 1/5] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120330101414.GC21950@opensource.wolfsonmicro.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
 <20120309124119.GV3273@opensource.wolfsonmicro.com>
 <CACSP8ShU5tu=9N53PtYMLyFVFMS9whNRhMvu7nu8rBoPuVCy+Q@mail.gmail.com>
 <CAJ0PZbT728rhQ5esf0arRw-TtgBGMCgAvZhW9-AejmbT9WOahw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Content-Disposition: inline
In-Reply-To: <CAJ0PZbT728rhQ5esf0arRw-TtgBGMCgAvZhW9-AejmbT9WOahw@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 30, 2012 at 05:56:01PM +0900, MyungJoo Ham wrote:

> With class_compat as in patchset v7, (this thread is w/ v6) does the
> issue (missing link from device name directory) still exist? (I don't
> think so)

Not unless the uevents are issued with both names.

--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdYdsAAoJEBus8iNuMP3d08AQAIrlh8CHoFB/67nOMO2x3ipY
XeLTGF/NfXqT1gofhL7j73hbUzYfy76TGqXpZMmBKocyyzZqSs2Ey5L2mP8JC5KJ
AOwkM2OhwaL1QL5TqO0NHmNn1pJcsvOa3xBccjRqZy8rVodQQjTewb54lJaXeDCv
oZh8bbQH3javfnc8hzCGA7dNMETkyqFQ0Cl/+vhEoa5IeevdIHD/0WRSxEIqmYO0
LNgan0479QeBfJuPYu9HVUtXnil7vq/7/bolTJQ0J3vRQ4lMreVQcPpjkCYiAxWu
pTnRKSKcvPmPsUu+o0HzU1lFxqL9shFOf7qp2XUyDD9bh2VzoJwO586M1/lPG3oM
o2CLTrkZEvd1d7dH4LtIEb53bNJuz7YavSJEdMmcnbIHUpguE+BsNBNp2iaWS20E
K5Oi9xFItFLLSjg8DR2fSXvVFeXVKVSWNIX5IDlZseDYXGrMeREgRyota8bTd8pT
cXKHQghoHWvT3ds/7MhV2n0LW+kPCcHrUvXl4gGUb7QrwPdydb9IENcQt7I/mwM1
JSBh7vKQBhFqPP8QwhX/nYDl5D9wDPEEtYzXYcX2vOTjBCrHpHhl+gMVp3pVDEvD
xvqh4JM4hoCLWGTnVsf+u9bPS0dGvePNaNlULbCKrkgqVagIEOmIfelcH/04G0ab
MuzxxV+wZkkVEUMisB6p
=nOQi
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
