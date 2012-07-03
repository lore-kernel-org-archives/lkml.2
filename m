Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab2GCGL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:11:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204Ab2GCGLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:11:25 -0400
Date: Tue, 3 Jul 2012 08:11:15 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-ID: <20120703061115.GA27989@avionic-0098.mockup.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
 <201206301920.21158.arnd.bergmann@linaro.org>
 <20120630194139.GA24300@avionic-0098.mockup.avionic-design.de>
 <201206302012.32476.arnd.bergmann@linaro.org>
 <20120701065639.GA25470@avionic-0098.adnet.avionic-design.de>
 <20120703154318.9e32d4a490c0b32e7d955ca4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20120703154318.9e32d4a490c0b32e7d955ca4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:KKdPOGzK4rVBTBLuZQ1roJxZ9+3FJsXoPHQ4pGyOGtz
 VoI3VLnt5VmMLkNbAu+QyZ/Cp55WlpPvzXzGAPwQFfozLDPuZr
 cAM1hu367gHV4Z5KYVyew4E/0wzM3HeNYRy57b2H9jmPnJD1jI
 RHx058U6iMj96j01ELAqM0VSZ7UZS1lemH/QWCd/jeOfs6JG0u
 2ZAAOUnYq+VCLoqX9P47GqVCaZtmS8oQr4IJOludCE3561hqIC
 ITskdtgU//EePo7b0x2pchY0qzk6LsHvm0AME0vB+Zkd9Q22XU
 qlaCG5YY7qvV64fsb721UzIPAjvR5tg2hXRrP8omZZrY5mQ/il
 +/m8OmxgFFB1xUAJztefAuc4Br3NndX8uof1anIPerVZGt5++x
 b8IG5pXiXz1QphQeIJ0wW3+E8Rw/zLkv3A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 03:43:18PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> On Sun, 1 Jul 2012 08:56:39 +0200 Thierry Reding <thierry.reding@avionic-=
design.de> wrote:
> >
> > But if we make the new PWM symbol conflict with HAVE_PWM, then it'll do
> > the right thing for any of the legacy PWM implementations, without
> > having to track them down. Furthermore it'll also keep the legacy
> > version by default and not allow the generic one to be enabled in that
> > case. This is more likely to cause less side-effects than the other way
> > around.
> >=20
> > > One question though: if the generic pwm implementation does not set
> > > HAVE_PWM, how can a driver check its presence?
> >=20
> > The driver depends on PWM. HAVE_PWM is the symbol for the legacy
> > implementations, while PWM is the new PWM API symbol.
>=20
> I am still getting the mutliple definition errors from my powerpc
> allyesconfg build.
>=20
> $ grep PWM .config
> CONFIG_TWL6030_PWM=3Dy
> CONFIG_BACKLIGHT_PWM=3Dy
> CONFIG_PWM=3Dy

I don't see how that can happen. If you have CONFIG_TWL6030_PWM=3Dy, then
you should also have CONFIG_HAVE_PWM=3Dy, which would in turn conflict
with CONFIG_PWM=3Dy.

I'll have to fetch a powerpc toolchain and try to reproduce this.

Thierry

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8o0DAAoJEN0jrNd/PrOh1wEP/RIYM9bSnFt7as74fzSgK01v
lTpbRiJmeHPDMfGF2k5sR0chxjmTW5uERjO8O7opqKjQtKqeWRtlfsJlA6B1pWN0
dDqVLE+XJlidBLbAwWoJUU1qPSjLHMmluBO43+dYvpuYrQb8V1FKbAlITrgP3zPq
k3SIejeyUR1L+UyvsV4Lp9LaFU4iG7MJGTAfm3EDYoT9sAddg9LIjAOl5OgDGDqY
0w9SCJLAgMC1YFttNEVWMHJWf3z59odLq11E6hg/ShMRhkG6p4/brpbswJOrSMEn
Nzyda23sAMSBQgu57J/9HZqtrRvZpnLPTNeMp5mso0Ffyqit4XDkrLxGEQnNZrGP
TaPGrqr1Txcr97vZgMTisLfyMA4XrtF2xqxeWBdibWZGmgHhiEIjZ5UsdKS88EHa
Z0pe7a6WR6rf/dE7I/gbkeokz5+acYKq8aT/HfItjYo5ajJuG1hRkgtxpdaIkwpM
GoxaZ89rFp7ZAoAqlau3hQES49W0CnStwlFoIVK4CwF+icr0506WKVlT3pTDlZ1i
aYcP4zlOXnPo4aeEC+MtHM1gT8jwUqK9un5xQxH+2WLBwxl+rbjyjNkCGJ8aximM
VITil0bNO7WP0obdEXmff8keBahj7Zwftg+BYU8AWkekwoZaPcnwiBM2LUGNFGU2
OUe0+lsAKHCGF/MpPnUS
=+wwd
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
