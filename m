Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030828Ab2B2KNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:13:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54391 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030553Ab2B2KNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:13:16 -0500
Date: Wed, 29 Feb 2012 10:13:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20120229101313.GB3182@opensource.wolfsonmicro.com>
References: <20120228165857.5abb225e1748d40f9c5d61e8@canb.auug.org.au>
 <20120228120037.GD3683@opensource.wolfsonmicro.com>
 <20120228140810.4cf9d477.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <20120228140810.4cf9d477.akpm@linux-foundation.org>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 02:08:10PM -0800, Andrew Morton wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > > -	for_each_set_bit_cont(i, lzo_blocks[0]->sync_bmp,
> > > +	for_each_set_bit_from(i, lzo_blocks[0]->sync_bmp,

> > That looks about right, yes.  Not sure what the best way to handle this
> > is, perhaps maintain _cont() for a while?

> I don't think that will be needed - for_each_set_bit_cont() only had
> two callers, both in arch/x86/kernel/cpu/perf_event.c.

Well, by "a while" I mostly mean "until after the merge window when the
new API is available".

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTfoyAAoJEBus8iNuMP3dOvoP/0KYp+/zcGvpV1vJRGm3H0US
r3u3gqU9ozrgR/Rab9FWIdYcwMxVkEHrsfkdTVtyUNi0B/GyUR4Fa8v0IN+gZcko
cCXvfFjjVs2MbjyQ+mw3dvGdw7mLc164qV3jajyCbybk/yADE+rN6fwBoZoa+nij
oLQ7OINXJJDs+MnOGaYH0L7rlPn2+2ko2ATjZWSQijY2Tu7K1SctpIVYF2ovWa1T
B7u4HreCYNNiLDa9v57iX9JdVwkHFT7nHFgLx95Tu17sJxU/3oWZmPhEt8R+2xPK
J8uQQl8hu32ZOw+UkE4ubIihAxrd33pcz4snchw+oLolduFNeEQD9s2SgQkVqaKp
Da3QDbvE8bDAK6fVOm2NgxLRrfkLPSEHMY0RyWigO+2+EgotI7dkKCSG69AZsIxW
2M2gudEiukrVhTGFdVhOcNTajixPaE8T0O5yI1QLfetIt2y9dNZt436bB535BqiX
IY3Cs1wyvqIxvJ53A/sF8WcRhaxknYks9iLAhlpqk+IQpZyf/4ObGF+pX7VSxu3+
wKOBNIojY7rrSKC9U4dwB7/tt8OrhMS47HanO3Hz8g8hYJ3rsNDUkMSINmF9v7Qw
X9JD1NqD4db0blPr0Jwjmln2UM6aydVf5lo4KDIQFXG0enD6NbyaM97vMvLOBpPZ
HELWIHF48aL2hUxUKwNQ
=5Zlh
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
