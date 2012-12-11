Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2LKM5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:57:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44227 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267Ab2LKM5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:57:20 -0500
Date: Tue, 11 Dec 2012 21:57:14 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhilash Kesavan <kesavan.abhilash@gmail.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, sameo@linux.intel.com
Subject: Re: [RFC PATCH 2/3] regulator: max77686: Add support for various
 operating modes
Message-ID: <20121211125713.GH9097@opensource.wolfsonmicro.com>
References: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
 <1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
 <20121210064650.GJ10927@opensource.wolfsonmicro.com>
 <loom.20121210T091624-754@post.gmane.org>
 <CAM4voanevLVXW5_WFts2cjDi-5aAbj1_2=EN1amfp14KnKXNug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3yNHWXBV/QO9xKNm"
Content-Disposition: inline
In-Reply-To: <CAM4voanevLVXW5_WFts2cjDi-5aAbj1_2=EN1amfp14KnKXNug@mail.gmail.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3yNHWXBV/QO9xKNm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 10, 2012 at 02:06:49PM +0530, Abhilash Kesavan wrote:
> On Mon, Dec 10, 2012 at 1:49 PM, Abhilash Kesavan
> <kesavan.abhilash@gmail.com> wrote:

> > Mark Brown <broonie <at> opensource.wolfsonmicro.com> writes:

> >> Binding documenation is mandatory for any new OF properties, please add
> >> this.

> > Patch 3/3 of this series adds documentation for the max77686-opmode property.

There is no point in splitting changes like this up, it just makes
review harder - in this case it caused me to not read your patch due
to the missing documentation.  Put the whole change together unless
things are getting too big to review.

--3yNHWXBV/QO9xKNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQxy1XAAoJELSic+t+oim9NN4QAJniZUKtXd8T+0qAbauGhp/i
nnvPtBVz9qVM2ePxP38sizAhPWh7ScPfcc0mQwNvj3cTeiQiWYDI+HeXqOmgGb+W
h39JvQ8xJmRCICe+yaWzgwW0aGvl4rlQKsEMkqJVZY+A8vF+bQCrxp+1sI8bnsCA
FjCPgl5YS7M7mYX3qRql+B6r7G7sEKV3lKZgPqSIgjCLOv5DZc5Vj+pqLMtskkFi
L6C6OyRAQ6a6muO+N1p6t4yRKevyEoSkdfS0usc8+vwC34jxd8140FOVvoFWw2Xf
8qkzzo/D2BKw4H3CmX16EmbiyAtjEfDbqGpUCKtQCYGzGswiBa4CzbQOe0ORO0kp
DDF1FrCgnYYIZlFdpFi4IFfCLNKV0+BwGpbq0aBSza+Sf7mBthvMHlNsTVeH9eSa
/4U7aZRR1z9gJpNmz47ttppPZYa8sQ2J45mLSvVKmCAOeuxXL8dl2ENect6T5yGt
u4s2UzFNRXJMduqs+TIq/RoLyxssI8Sx8fK3meNXpLEboWTjBf3VMM2AgiQcHbp5
vam7Y6CX/oK4EqQRGST4ggmgkPjFTFD2H3bHW9PnEI5yXn6CQD5sZVjKYocnsH7a
5/MFC8SrnbN55hfRpnvYX/RUeZ1o/usmRM60Twde5KuVqvV8IeXBsc9oWQLd5/V9
eqpxHw+qoYQSKDWUnfYs
=Vd+K
-----END PGP SIGNATURE-----

--3yNHWXBV/QO9xKNm--
