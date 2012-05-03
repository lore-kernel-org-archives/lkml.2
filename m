Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab2ECRXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:23:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57867 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab2ECRXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:23:13 -0400
Date: Thu, 3 May 2012 18:23:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503172309.GT3955@opensource.wolfsonmicro.com>
References: <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120503103848.GB3955@opensource.wolfsonmicro.com>
 <20120503112803.GA15752@localhost>
 <20120503113801.GE3955@opensource.wolfsonmicro.com>
 <20120503150040.GC15752@localhost>
 <20120503152407.GK3955@opensource.wolfsonmicro.com>
 <20120503165437.GF15752@localhost>
 <20120503165748.GS3955@opensource.wolfsonmicro.com>
 <20120503171402.GG15752@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7Ha3rcGc4ZVRbLT1"
Content-Disposition: inline
In-Reply-To: <20120503171402.GG15752@localhost>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7Ha3rcGc4ZVRbLT1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 07:14:02PM +0200, Johan Hovold wrote:

> Assigning a current sink to a control bank corresponds, then, to
> setting, for example, output_lvled3 to (led) 1.

This seems sensible enough, though it does feel like what we're offering
up to the LED subsystem is relly the LED control banks rather than the
LEDs themselves - or some mix of this and other stuff.

--7Ha3rcGc4ZVRbLT1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPor7yAAoJEBus8iNuMP3doTAQAJbTPKp+sTnKvltziyw51dLx
GhKI4d8jp5P/v0e5Ljto/+b4EQPY5IOkWZiCRpshUv/Uq5pRo9fO1MztwFGTW9pB
WntV0NASs/cCA6HWKcwg+S5Dls/cFt3kzzfJGiwgSd60yuE6PvK1hi6s5LSFP8xM
4MixB7LB45F4oqOrO1JCTrmmdMpTVu57C6jWjqk5oRoBhXNaj97S9M9/U8jSpwg9
+QXU0LiyCl0cBS1DlH7kr2MTjbxVOMH+wGDI8DFOesce/T0ATrRIXriqBk4clwc0
V/8LKZvpRX3wzqSBEUptdzMCyzLZFa5/daqB8+NMKA3Q29XSlnZeQoO40cDNTbGa
oPfAZRBrD51P6+qZ+jUxs5MJN1T+nLtLo3ZzGkG+ve+gMHKFjiNy2sO7eA7ceU1i
UGkLtTq/vzHos0h4Ws/62cUTKSPGIE4hpSk3JWvH5rQEb3/s4ukIOvRVBUQt8EHw
MLSAX5VpZzAJlivwdqLUuAV8yHqLtMQFgQf/fWVUw11s+uDrFW66fW53vW5LVLoj
IdbFq1MaU6Gy9hjaOKgBn9y2s7YDVZZ39gS+UKIkQLvHFJqqtPtOD44kIyLA2p9Z
GmYWxpCKfsnyH8r2ohNLW/kdxQTo0xJAGy8LZPNdiV/8WzsX2trJz9z31sYWAn63
X/b6HlJWTeVszT2DD8jv
=ac5q
-----END PGP SIGNATURE-----

--7Ha3rcGc4ZVRbLT1--
