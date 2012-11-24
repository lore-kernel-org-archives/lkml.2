Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2KXUww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 15:52:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2KXUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 15:52:51 -0500
Date: Sat, 24 Nov 2012 21:52:44 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: adc: Add Texas Instruments ADC081C021/027 support
Message-ID: <20121124205244.GA27042@avionic-0098.adnet.avionic-design.de>
References: <1353683583-19779-1-git-send-email-thierry.reding@avionic-design.de>
 <50B0A74B.10707@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <50B0A74B.10707@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:1eYQOxq1F0zuLp1pzHos+IcLWg4qL0J77qc7TBCLLgu
 T1fq06WA37ordTPF04MIffMVoBTdP4VwnZ89oTgYr+cHl7yLP1
 74ArBUqagHr67aJfx7F/ci769Lv7w9xtMGTkwuXqaOHfVyB4F8
 cQi1ygRoNiKycsH6ZNXDdJcSbobwW6RTav8Qqmx/05Axc5HgyT
 o0M6YbioSrCX94CQM0Ub1fXuWUrHy/Xm3zzq1XS0ZKfITd2mE2
 KQxqXsKpQz3O1KPCzdLcsGmv+BY3ffNmkroAeY9bQC2gnzJ/DM
 ZBhUBDHXj+K06H7pwBcQHWy2w49T06GtJvleI5dvwQvlDdhYGW
 TtxF9SfxXqEDhc45DSmzdFKern8y6b7yX3//QyjRFCLbxn5wkL
 eBYk+HAfh3MRrKspiUz58qoi3Z2op5OrnwWBPClALw5GU1k5sS
 2rfks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 24, 2012 at 10:54:03AM +0000, Jonathan Cameron wrote:
> On 11/23/2012 03:13 PM, Thierry Reding wrote:
> > Add support for reading conversion results from the ADC and provide them
> > through a single IIO channel. A proper scaling factor is also exported
> > based on the reference voltage provided by a regulator.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Looks good to me.  I think timing is against you (depending on what Linus
> says with his next rc).  IIO patches are routed through Greg KH. His cut
> off is 1 week before the merge window opens.  Mine tends to as a result
> be a few days before that.  Linus stated in last rc message that the one =
he'll
> do today or tomorrow will be the last for this cycle (and hence merge win=
dow
> will open in a week from now). Hence this will probably hit linux next af=
ter
> the merge window closes and merge in the 3.9 cycle.

Not a problem. I wasn't relying on getting this merged for 3.8. Official
support for the board that uses this driver is still some way out, so no
need to hurry in any way.

Thanks for merging and thanks for reviewing, Lars-Peter.

Thierry

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQsTOcAAoJEN0jrNd/PrOhe6EP/1edWQawxCXyL9BVzNxWnI8Z
CoIUX4e2/4qWE/rWvcIYfOJHeW+JfDCVpE5KL5HkTw8z7pQHmHo+A3ZtmH3Fxd69
Pt8h6WV8cGu97trRJrx2B7nQcZvfB9Y9LYb3oaUsp7+HqT2QS6bDKpSgkUDlc80n
EhRAmH3ZmQsEo+JA/JbU7cpSDx89YejkMZBOY1qynZsIWn7/+gRN/1PLrDuY5W7S
vq6MpNb9+E8In7TrziuCUgV1udHw7cA2/zhd9v5g3oooECp4Ss/My42d/8EETe5K
nFwegC8U8AlW5XriveyjWst8HVBYfkaB38FyVHWMgE/3s12vj+3/Pdx3Igzym4/Q
UHeDQzHCWryAytO/GMfv3ThJbC78e+dBMsi/ovUny9gYL1kPlTiVYU4YAnnDoPJb
NLZhe7w5N1nEkBQwTsmJ2kgmCmofSp+Tc/3KerpJnRlm4m+57NCJW/0r/iQmjHvw
VHm068X/lqGnbGR8q3qUC7jxuKfqwmol21A/SoPtWN5mGdt4sudbA7RbJr/fGz8t
pnTxWPiGtNZYprXfnbpWScAsYQ2xFln2UoFp+1n/MrahrsPSBdztdqKrinMJQC6x
ck4UupJEzEcWNW87c8vKQ20w2YtlhByM3SqrhhvvBoScIx4qsHDeT8Lg/pFSDKAu
n1isXTzFd3KO7q+S/TeV
=BMJJ
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
