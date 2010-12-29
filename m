Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab0L2Jqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 04:46:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53396 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab0L2Jqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 04:46:53 -0500
Date: Wed, 29 Dec 2010 20:46:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: Tree for December 29
Message-Id: <20101229204641.ead941fc.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTin1pizZM5LttTpYQOo0gPEeV7Jd5uD5RXwnj37Z@mail.gmail.com>
References: <20101229130700.0ef93735.sfr@canb.auug.org.au>
	<AANLkTikq50KLGwS1_=uA=TXz2b=LNzr_TKUSiZu-an1m@mail.gmail.com>
	<AANLkTin1pizZM5LttTpYQOo0gPEeV7Jd5uD5RXwnj37Z@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Dec_2010_20_46_41_+1100_X+EW7Of6OFPaEz7/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Dec_2010_20_46_41_+1100_X+EW7Of6OFPaEz7/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anca,

On Wed, 29 Dec 2010 10:58:02 +0200 Anca Emanuel <anca.emanuel@gmail.com> wr=
ote:
>
>   Building modules, stage 2.
>   MODPOST 2808 modules
> ERROR: "__tracepoint_snd_soc_jack_irq"
> [sound/soc/codecs/snd-soc-wm8994.ko] undefined!
> ERROR: "__tracepoint_snd_soc_jack_irq"
> [sound/soc/codecs/snd-soc-wm8350.ko] undefined!
> ERROR: "__tracepoint_snd_soc_jack_irq"
> [sound/soc/codecs/snd-soc-88pm860x.ko] undefined!
> WARNING: modpost: Found 59 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2

It would be good if you could publish your config files with these
reports.  I have cc'd this to those who may be able to fix this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Dec_2010_20_46_41_+1100_X+EW7Of6OFPaEz7/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGwOBAAoJEDMEi1NhKgbsghUH/iVgysSm039WYRJIo9qmUyRl
8lAZOt3FC3boWe3TtNqtJ33QxDmws/PhKdHmC8VBkyr9BYkSJKGiZeG+G/ed/BES
7WcUVb0AGcOLCMvlmmJ45HQIxWBeYLVsUCva8oM4jGePGHt3oiNyi2ZzjY1xWjZB
esEn2yVwwuAFiFyDRrBZLgKYgzZSY+6COWcgZZzC/C4NOB9T05dfd2jnNNSD3Pw5
/ADOd3IcTukYx71dKqOS8QOjqSzLcwI8ThM2ILFw/2IoHA4io5VGg9n6bKn/2gfK
Qw/rJXtqcgU/sqJvSwD5qD6JGILcWR9sZNvRHYCN2dMWKsZW+x7WiwklgylxkcI=
=U5jk
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Dec_2010_20_46_41_+1100_X+EW7Of6OFPaEz7/--
