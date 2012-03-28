Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2C1N2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:28:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab2C1N2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:28:44 -0400
Date: Wed, 28 Mar 2012 15:28:40 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        patrik.r.jakobsson@gmail.com, linux-kernel@vger.kernel.org,
        greg@kroah.com
Subject: Re: GMA500 support
Message-ID: <20120328132840.GA26353@avionic-0098.mockup.avionic-design.de>
References: <20111121182910.GA2856@Boggieman>
 <20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:UullkLPkbbO/5+eVpNfCvUUoMEPe6E/5l5j316Ap+se
 HfnlLMUmyi7i3osjblNAWn7IcPP5SixZvMYiurSUvFon9n6qEU
 fKCOvnJ4gX5xw52c8xjl+sybdgpOwr7CKK1mqBH/UbxVcHqDzR
 X5lBhqYdoqEM+VA1lfL9YR1VJ2vn4yZyn6PUPTsPfEHUhCINQi
 v9hRVeoihYYgdfrZo2DyEJvBJfMN8vsTpv5P7JiNEsaaY6Znx+
 lfrHZnjmyCyqUahyiknoNLHhsqnmq9BnvFIwFaFvacwsHuNPNn
 U+pWcCe1fMcp+hIXAsxhEhqgsamy91tOEh6rPHsLNM7w+jI7gz
 jp83GYJUJeQuC/esvo54+u2yRrZcby7nMyqzM9Dw1Jo1xYq3ju
 hpN7LDzr/Dgbk8v1r8RU9KyH0wz5GDAD3M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Alan Cox wrote:
> - Video playback acceleration. In theory there is enough info in the
>   VAAPI code for GMA500/600 that has been published and in the old
>   'binary X/source kernel' driver to do this but someone will have to
>   work on it if they want it

Hi Alan,

Are you referring to the VAAPI driver found in this repository?

	http://cgit.freedesktop.org/vaapi/pvr-driver

=46rom a quick look this seems to be developed for Poulsbo, but since you
mention GMA600 explicitly, is it supposed to work on newer hardware as
well? I'm specifically interested in the Atom N2600 which has a GMA3600
(0x8086:0x0be1 to be exact).

I'm also not sure which kernel driver this was developed against. It
looks like it might have been against the initial staging variant. At
least it still has some references to TTM, so I guess anyone wanting to
port it to the new kernel driver would have to convert those to GEM.

Do you think that would be doable? Can you say if the GMA3600 is
sufficiently similar to make that driver work?

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk9zEggACgkQZ+BJyKLjJp9/ewCcCKa6KJJPbeG6svpHrrZDFTHD
IBQAoJOsWgIOpLyv4kmDn2spXQ1FWbmL
=uylH
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
