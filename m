Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2K1Ler (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:34:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50435 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169Ab2K1Leq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:34:46 -0500
Date: Wed, 28 Nov 2012 11:34:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Navada Kanyana, Mukund" <navada@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Message-ID: <20121128113443.GM32691@opensource.wolfsonmicro.com>
References: <n>
 <1354094577-14967-1-git-send-email-navada@ti.com>
 <20121128092924.GJ32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959AED@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WuedheRyq6FDfQ9j"
Content-Disposition: inline
In-Reply-To: <6817C817C9581447825BFB369EAC42163E959AED@DBDE01.ent.ti.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WuedheRyq6FDfQ9j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2012 at 10:11:05AM +0000, Navada Kanyana, Mukund wrote:

Fix your mailer to word wrap within paragraphs.

> > I'm sorry but I can't understand what this is supposed to do.  The
> > current paging code expects pages to be numbered continuously with no
> > gaps.  Can you please clarify?

> But the page number is expected to increase only till end of range.
> But in devices like TLV320AIC3256, the page number increases beyond
> range.

What does this mean?  How can we have a page beyond the end of the
range?

> Pages 0 through Page 1 --> first register range for device
> configuration. Page 8 through Page 16 --> second range for DSP1
> coefficient memory Page 26 through Page 34 --> third range for DSP2
> coefficient memory

> Window length of each page is 128. So if we need to correctly write
> the page number in selector register for second range, start_page_num
> would be 8. If we did not have start_page_num, it would write 0 to
> selector register.=20

I'm sorry but I don't understand how that would happen?  What breaks
accessing page 8?  This sounds like you're doing something wrong when
you're trying ton use the paging.

--WuedheRyq6FDfQ9j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtfW4AAoJELSic+t+oim9v38QAJH+TOAFQRWm1b2azij1C5jE
kqpz7nH30PYsuJqg6ow7uUVf1Sfigqt0AoCbdx1P6RTyHriMerFNpG4kA2s9K7SJ
7LTuZNbTjinaZ8jbfArp80NONhstS4fpWoIduZFrLAin6yTspfrTLeKV19AvpT8d
RmU2m3+Kuj6l9dga/s7LXfJLYZq+JH3HxF/xY5FTEYE1A44SEZUjq9ErvFJQFmAa
KewElvpLk73md7hbo/3wDkq+nVYc8cQ/4spLzU3NJthpxlsBn8aQ32v9qMbegMU+
LFsaMjE8j0AdaSBx37+XmJZKWEt62uTP36K0fccTukV7FFhI1SoEs1A7jnvXYYvJ
oKUYSL/PcIXTkZ4eNeIdAInsTuJwJ+YDykDP5zT0qbkzc1D5yE1eF42nIFdrFjip
hMieqh1s+aRFGHlzviBbFKATBKNF9yDr7WCTLQGDcU3Tmmjgwnnj+hcrExgkPWql
8bzZ2VLaHyCDHxBW/XJwreeqiXQys+tY+WC7GU/vkWTf4Nnz4Ko5uv/vN7mkEurT
xYjw50JqNhalI/pKyMf4I+1CdWMIjsPBbQSGtwVDZdd22P5njbRHFjj3/KMsY+Lf
LHWUcZSncRwjN12LBGMxZ+u+fLio/eAXc6k+JxjqsUW9Ifk8GS0XfqfOVkUFhpFg
H6x0cFhmlzZ5vvJ4Vn/R
=PJVW
-----END PGP SIGNATURE-----

--WuedheRyq6FDfQ9j--
