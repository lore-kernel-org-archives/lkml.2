Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab2HIFpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:45:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2HIFpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:45:44 -0400
Date: Thu, 9 Aug 2012 07:45:40 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pwm: add devm_pwm_get() and devm_pwm_put()
Message-ID: <20120809054540.GC29806@avionic-0098.mockup.avionic-design.de>
References: <1343816458-24699-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <1343816458-24699-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VNiH05rn+q2vR6JuPMETP3WpMYZ/aB8XiPjT9SbW2fr
 HwcEebot2t9+lMNGuvhTOhAvegvOuopOkFABd9rXcroMtfbqCb
 8sri+6Yb3OS5q1x3Tf3zVQA9Q+xs2svC4PqdyaAUO+juuUNjA0
 tDXRIb3MxP1ZR63WfdPm6wH1bhvx/qGk7zWmzXV+4sBdnWxWPy
 2vPEEiHyVKtdnyAZvImQkEWs1Ka3PVFOdvxnPiV4RDmlunItI1
 SB+4uQjZ/jdpQxlP29xORkK9gqZ6qzkL6C8S56rGnL/mz2OGPp
 0co1WFFJUX6tW7KB3qxIaVgFhBU5RhYOuMgLKzv1f1jAtk1Zfl
 Vzq1PEaOeBSUdFGRmxxqTfR0Zyu46yFrbH+D82TPzUmeKvL0mr
 1XYF3YxYhyC5qSi1EACTjL28llcWs9PZfkoq5KxKv4ikLtqbji
 /4ZK6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 07:20:58PM +0900, Alexandre Courbot wrote:
> Add resource managed variants of pwm_get() and pwm_put() for
> convenience. Code is largely inspired by the equivalent devm functions
> of the regulator framework.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Applied, with minor editorial fixups. Thanks.

Thierry

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI06EAAoJEN0jrNd/PrOhXh4P/i22HOV6dCLPmjrJho9WteDa
5w4xT7X8cZkCS8A2fHz6wLVhiG2gOFCAqvoylJJug8H82s8KFYbKnAzO3SYO7E6f
OcEYFQEaYtEDQhEaZj4na0m5+frqyzC1uo5u+zLOsC7trr4BlFLJ6Tbdzf+ZY0Hb
E2CrgY7gTXx9ZJUzculwInmno+jLHkXKJw54mGhzuPbqwWb1TyRWbQ+QumWNj+1d
NObkRvBIX14HgbbqLT9qyAdgKEl1BjDR/7chcGcDoXgLWi8MbQu4rmQjzusMmcl+
EMjR3qqkvQtH6OfBJBkbJjV4Cti2iYx5RxXf2Ub2D7OiSL9tXxX/Cb9ARlqnF4Tl
L48qa5c/aM7QGHu1Joshgdo8sO+HOxyOJz3vTYbHKa/yDh6jeHZ444fJQuZeJqJ2
ruTPndD3QtXi4Qj3MauUeNLKoIEr990fl99Adyv8BuzYEPY2m9/EoE1ZHDMCVLNO
3lQ05FsVrJgyU9LqbvIS4MdyJODZK9l8Ncx68W5/YTUcebEtUKqRE6gW+HhOPJ2/
MMqdefCluXEQ29wWn/xlzLn7QOQwNnrQVUMDUoz2TafX2FIS72SZPLdx5g1yD9rA
+k73HYI8koYa25AlI/GV0SXlBjzfkAmeHaQdt5MSSKOID03i3VyiuHSX2galvw0D
74F1xrpWOmpy8sq7qhM+
=rs+9
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
