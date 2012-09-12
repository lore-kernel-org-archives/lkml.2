Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2ILMqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:46:44 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:40496 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab2ILMqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:46:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArADAKaDUFBbdWObgWdsb2JhbABFhgetJiKHcSIBARYmJ4IhAQUjVhALQgICVwaIJKk3kyeQQIESA6hm
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="asc'?scan'208";a="967352794"
Message-ID: <1347454076.4539.168.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 03/20] Staging: ipack/bridges/tpci200: provide new
 callbacks to tpci200
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Wed, 12 Sep 2012 14:47:56 +0200
In-Reply-To: <20120912122814.GB7164@endeavour.taprogge.org>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
	 <1347267118-9580-3-git-send-email-siglesias@igalia.com>
	 <20120911084702.GM19396@mwanda>
	 <20120912092833.GA24558@endeavour.taprogge.org>
	 <20120912111330.GD19396@mwanda>
	 <1347448877.4539.164.camel@fourier.local.igalia.com>
	 <20120912115926.GF19396@mwanda>
	 <20120912122814.GB7164@endeavour.taprogge.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GqQtCHrZEq0S9bC3C09Z"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GqQtCHrZEq0S9bC3C09Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-12 at 14:28 +0200, Jens Taprogge wrote:
[...]
> Sam,
>=20
> can you please add the endianess-aware versions back?  Patch attached.
>=20
> One of the earlier uses was not correct.

Done!=20

The patch will be submitted with the next batch.

Thanks,=20

Sam

--=-GqQtCHrZEq0S9bC3C09Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBQhHwACgkQWrfbyfmd9eKP+wCfbGPwZPO78FPe48HpBebEslTn
UJsAmwXGSLikUesEeYOvz03PBWAIRC6J
=Z6HE
-----END PGP SIGNATURE-----

--=-GqQtCHrZEq0S9bC3C09Z--

