Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2EGQeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:34:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34689 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757369Ab2EGQeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:34:04 -0400
Date: Mon, 7 May 2012 17:34:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jarod@redhat.com>
Subject: Re: drivers: Probable misuses of ||
Message-ID: <20120507163400.GL17002@opensource.wolfsonmicro.com>
References: <1333580415.23520.29.camel@joe2Laptop>
 <1336168477.11505.6.camel@joe2Laptop>
 <20120504220241.GA6279@sirena.org.uk>
 <1336169378.11505.10.camel@joe2Laptop>
 <20120504221333.GU14230@opensource.wolfsonmicro.com>
 <20120505160042.GA26922@ericsson.com>
 <20120507083602.GA4415@opensource.wolfsonmicro.com>
 <1336407634.18931.5.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kkRamCq5m5VQq0L6"
Content-Disposition: inline
In-Reply-To: <1336407634.18931.5.camel@joe2Laptop>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kkRamCq5m5VQq0L6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 07, 2012 at 09:20:34AM -0700, Joe Perches wrote:
> On Mon, 2012-05-07 at 09:36 +0100, Mark Brown wrote:

> > with no analysis=20

> You did elide the "Likely the || should be &&" preface.

By analysis I meant something like "...because X".

> > Compare this with the reports from people like Julia Lawall, for example
> > - they tend to be very clear.  Even simply adding "...as with || they
> > will always be true" would've helped.

> I think it's a pretty basic logic error that most all
> lkml readers should be able to identify most of the time.

"Can spot" and "will spot" are two different things; speaking as someone
on the receiving end of lots of mails it does make a big difference.
Cues in the human written text which show someone thought about the
problem help a lot with catching attention - the more effort it takes to
understand a mail the more likely it is to get skipped, especially if
there's no patch.

--kkRamCq5m5VQq0L6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp/lyAAoJEBus8iNuMP3dC9cP/3GH99lOn+LL4uqALlNpzoWr
W6JAXtJLFUrQDRvcdESA+1jCzfczxO6lhx+1ewKWcRGH2puO8X4cwC3a8WmhdW+a
XuGQUC5cW8M2n/rjPYTw5el2tUtuzyCGYj1yuUuCzr6XDaVytrsJuoTP7JWCKign
kENFi8y58nMwEH/4th5sWLeGNSOQtwwMMdr4yf+zDoOm6A3euKuioOMSUvXA09J0
+9ZqjfQzm9phPpAbod03VzPSU7jVzjGTwb7oZOHkG3Wg76T+F8eTfwkOz3ABOT7W
JqB2R97UT/hRCaQrUsBjXlNPEVttc+XvVBmpMyprnSmn6oQsU2ELJd7xGbwrhezn
vGMygJ/xip3uqB1jPkLgusGsBj49Njk3FENbH81V6DRCbqlpDj7t1JkuIknG7+ef
U+EDEXO6Qaz0HNQ6OEnb02RcPch8tjDw6PxlR24sWakR4c+G/4Qv02wtYYkumnfc
SqYRd7ngLrPFRjjv4zDLef0sezrfyLP7m0fU4cSOfMQdgfkKeKXZx3VYYTq2fXZK
jnWfHGjOmd7151f+4fBvscOxILFOv6BrAku8edNfY9FLVjk/mltvPM8ab2jwbcJb
Y2ef+NhjzGb4kTqfckcZg8D7BLx/F89Oc1+tEr5deKxBGgoow8vpz7YMOUGYjnHA
DAeM8H75S5RwvBiXdvIj
=wbD4
-----END PGP SIGNATURE-----

--kkRamCq5m5VQq0L6--
