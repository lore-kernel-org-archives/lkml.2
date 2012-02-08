Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2BHMwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:52:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37825 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932124Ab2BHMwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:52:07 -0500
Date: Wed, 8 Feb 2012 12:52:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Girdwood, Liam" <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] davinci: CQ93VC: remove machine specific header
 file inclusion from codec driver
Message-ID: <20120208125204.GA5943@opensource.wolfsonmicro.com>
References: <1326194863-31194-1-git-send-email-manjunath.hadli@ti.com>
 <20120110184741.GG7164@opensource.wolfsonmicro.com>
 <E99FAA59F8D8D34D8A118DD37F7C8F753174E3EC@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F753174E3EC@DBDE01.ent.ti.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2012 at 12:41:14PM +0000, Hadli, Manjunath wrote:
> On Wed, Jan 11, 2012 at 00:17:41, Mark Brown wrote:

Fix your mailer, not only is it not word wrapping within paragraphs it's
adding such problems to quoted text.

> > Applied but please do try to use a subject line appropriate for the subsystem you're contributing to.

> I still can't find this patch in the mainline, any issues?

It will go into mainline in the next merge window.

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMm/tAAoJEBus8iNuMP3dsmYP/iKOPt+AETzJ8DHMCZvXYR6D
uoeIPNATV1dDYFYzu0YVWXeKdanEcaW3syOfcy7e+ItrYDnHsf/JQ1K2UHSvxF8X
Sj2s81yLlwfVWkd4CYHH3w/muKLf0nshOv9XWqwe/Gx9ac6Ya0AoK+HyHrzkWoV7
cU1JxNIuIpXxdnhjPjIE4HDZcge3Vl6yTLLgT0KqA08XD0txtlsdk0bg47UtgpaU
EGtMJcwmIllo69O9nw4QBssxpBe1Ui/fHzlTNv4m3hZE6jCaiX9gzwNIdOfCQs8a
US5+H5WFXr3Wj6DqSvNs82ikQbGEOu3xV1nPWRt4cWRtzNuM3Y9ZtWIbP5J2R44K
bqLzq2iTRnfzBvJiR/C36aIqeZcTaIj3pOMsvNORy1E1KLZIVFKKNcfjiNbOnhtu
L92xtF86ThWmPwJ8Gx+9g405MYTwJGNuOQLwhtc5VGrFndJb6CTBhEUsDPpxbZpS
AARbJ5AT4GpkZjwGQh9X3L5fHYm5jB6M7ILN3EtZlQgHUG1E4UEzXEOOagV5XERw
0oeHgj92SCiDzxYvhAqm1soJt/0o47c+aKEQoQRPADjfuvS+GyGEVs50P/7LjXDs
n5aVRcZCuIWNyHRSJWgQKwLGbCX5fyz7rcuAWF5/rtnReaZbYPQYRQDR/NBmvDnG
uM4SGfX8MIlaSBxceU6T
=0pJX
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
