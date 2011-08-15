Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1HOP12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:27:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35752 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab1HOP1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:27:25 -0400
Date: Tue, 16 Aug 2011 01:27:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Elder <aelder@sgi.com>
Subject: Re: linux-next: build failure after merge of the final tree (xfs
 tree related)
Message-Id: <20110816012715.42665b49723cc48b1bd97610@canb.auug.org.au>
In-Reply-To: <20110815144946.GA8256@infradead.org>
References: <20110815161023.6227665ab11f8a35fd649e3a@canb.auug.org.au>
	<20110815144946.GA8256@infradead.org>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Aug_2011_01_27_15_+1000_3hN6tPnRno/bUedo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Aug_2011_01_27_15_+1000_3hN6tPnRno/bUedo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, 15 Aug 2011 10:49:46 -0400 Christoph Hellwig <hch@infradead.org> wr=
ote:
>
> On Mon, Aug 15, 2011 at 04:10:23PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > After merging the final tree, today's linux-next build (a powerpc server
> > config) failed like this:
>=20
> You'll need the patch below.  Can you keep is as a fix-up for now until
> Alex returns from his vacation?

Thanks.  I will add it starting tomorrow and remove it when it turns up
in the xfs tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Aug_2011_01_27_15_+1000_3hN6tPnRno/bUedo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSTrTAAoJEDMEi1NhKgbsEpYIAJAYYdVozfSSrHPyzYyoBIwn
2IGn5HP1cwHiS3Manhc3RsPhjzNnGn8tDM7hM20FYmlAia4lMMgdSEMMRRyeqB1m
kjnpHQ3DeCtH48fHnFhKeycLUe4wv6K7vpmMH2sQp1V5lfHaOBVr7gge01GeJNZr
2aqf2irP+zXyGjNX80boj99d6v4lfDwPvQi/NfjnhEeAo5/XlRvf45SzIRvRkzNz
XqaG2/YlzwGt+wlTjPndlHOQXjvNjlNUkb6wIbM3Z1XQVxe7zJHmsVitll0Psf0p
gJJLbjP1wszDhVwKyuV20z/1B3xo/hQcM7uL2mQVeukkmIy+wQ0S+SeBmltI3zU=
=Uwif
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Aug_2011_01_27_15_+1000_3hN6tPnRno/bUedo--
