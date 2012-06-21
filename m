Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab2FULae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:30:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57852 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759124Ab2FULad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:30:33 -0400
Date: Thu, 21 Jun 2012 12:30:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Kim, Milo" <Milo.Kim@ti.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>, "Girdwood, Liam" <lrg@ti.com>,
        axel.lin@gmail.com, Alberto Panizzo <alberto@amarulasolutions.com>,
        Jingoo Han <jg1.han@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: build failure after merge of the regulator tree
Message-ID: <20120621113029.GU4037@opensource.wolfsonmicro.com>
References: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au>
 <A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
 <CAF+7xWkzKkwfBFQS1vr-Tk2Auu+5HQmX7bZCGJhsmXRi0V5OZw@mail.gmail.com>
 <20120621210412.72321b3ff43d50930b17f760@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b9dEYEwnDXkv9lSy"
Content-Disposition: inline
In-Reply-To: <20120621210412.72321b3ff43d50930b17f760@canb.auug.org.au>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b9dEYEwnDXkv9lSy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 09:04:12PM +1000, Stephen Rothwell wrote:

> This export is needed for a patch in the regulator tree, so can we have
> that patch sent to Linus ASAP, please?

It's going to affect pretty much anything that tries to use the API.

--b9dEYEwnDXkv9lSy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4wQdAAoJEBus8iNuMP3dtQQQAJzv50ITMV2QroAbCuOs7GiI
xhEPaSr8LIaxRfyLGpBvN+5IyDp0+awbGQmk5+xsV9JjFX6WbiqotBbTyfA1X3Vo
K2G6/LP81QDBLj1sYHNsfYriFO29DKdfHvh31ueD4wznpaExSSofCRd3bVMygDd/
TSFDUvqcOkn6V20DmfsEo7MMkde/IyKH5C2yI0NDWXA4cO6senmXFPRvfZTTil+l
zgl+gDz/lpWFGvgn3P1wwYUPqDAy0BVIANg+2KqLZtEaYwpCb9vAV2u5GDrh+4CO
vhoNKX2/ONYgUGVGRDBXwtyhda96WyS23iuGizvMtpzfEiA6RWB2lyC7hJzgbT/b
mjE5A00tlZGXmSxNpqQFxhNsMB5t/a+8hGtyCQ8rpDT3Bu64RjkdTh4leXTFE48z
sRVJ/UFcOH/6VoFcquHFfS04hrOy3fTJFqWQ8xdvZ4/QyqgOVDnS287CE+PEB7dG
iNeYVsFYpk77FDekNr6iPke1bdhkfASNNSkjQNXraPkQAqLdxql0GwgPftLKI7GF
MGrqcBQz3yY4hcYNDpbbhwIaWoFaBC9BWE7DBjFyg7iBC+knOdq0mq3dG6l2DBoU
ND2lxKe1+GMmWNr2ttfEM9VepZ39Vyq9tBVwjKEYH+rnxyAF5Zie/iJUozVPEbGS
kWngkXhONZp5CT0i0cDt
=bU1v
-----END PGP SIGNATURE-----

--b9dEYEwnDXkv9lSy--
