Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2DQOR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:17:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33508 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab2DQORz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:17:55 -0400
Date: Tue, 17 Apr 2012 15:17:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix the logic to ensure new voltage setting
 in valid range
Message-ID: <20120417141750.GH6652@opensource.wolfsonmicro.com>
References: <1334148838.8687.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ISKrrfpKsPiF35CV"
Content-Disposition: inline
In-Reply-To: <1334148838.8687.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ISKrrfpKsPiF35CV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 08:53:58PM +0800, Axel Lin wrote:
> I think this is a typo.
> To ensure new voltage setting won't greater than desc->max,
> the equation should be desc->min + desc->step * new_val <= desc->max.

Applied, thanks.

--ISKrrfpKsPiF35CV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjXuGAAoJEBus8iNuMP3dk0sQAJcLU+B9GTtGpoQDkMhAF5bG
OZsn42ban82oSVoUdtbUtk4MLvA7Hj8qCCWieqzvM5OHmuelhJ5KpAqXSw6pxHJ6
cqik+3t/um0RK+b776eFt2/x8iHN0xQeXcIrt00KYtWe4ZYH5Q+92K8z+IpHiWjO
cKTW/IjJ9J1/1O0srCVN12UMD05Y77CHZr9Gu8ifudcm6b7CinC7qDULYDe8pg7N
5KBz4/9OU2YpDm8+tCROhieD8FMGLM8qZLrZqzX72T9yvD06ULbcDo4av1SM6pNu
mYY342WIY3S3x+30bDZI6AawYu95TWUqJSJdPM6kbrM330mpsVqzQtwpYle9ADez
xhrHEj+ooGDHpmKUwLIKWwrU+RMN2TcnejSVJgg14nr5A8RhiXFo11bP5OeyuS9Q
E13449T2comoK8cfI1M9H1zla8Yb7qdsuIR0RlqLiG+75elHg9ZUjgsHTgAHc3fw
NtSOTyQSJHVVkIH0DdFONyDVJKuhjULB/KEUovyqTrZajdW4q/aMtrnwy1IwMqKA
3BJnEtGd4n0AVjR8mVG6S54Svm4Rd6ZR+SgZ1naC/zzHDS09crZ1VBD+PzwgBZHS
nhP3zehT00TbckueQAWTeY8WOnsEn/ispNwJBYb/ZJHg6TF8BdmQfEnrwNZvPpO9
IfvyeqE175zP9lOQ2IKr
=szfo
-----END PGP SIGNATURE-----

--ISKrrfpKsPiF35CV--
