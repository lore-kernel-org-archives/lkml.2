Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab2I1Ljb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:39:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab2I1Lj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:39:29 -0400
Date: Fri, 28 Sep 2012 13:39:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: CMA broken in next-20120926
Message-ID: <20120928113924.GA25342@avionic-0098.mockup.avionic-design.de>
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
 <20120927151159.4427fc8f.akpm@linux-foundation.org>
 <20120928054330.GA27594@bbox>
 <20120928083722.GM3429@suse.de>
 <50656459.70309@ti.com>
 <20120928102728.GN3429@suse.de>
 <20120928103207.GA22811@avionic-0098.mockup.avionic-design.de>
 <20120928103815.GA15219@avionic-0098.mockup.avionic-design.de>
 <20120928105113.GA18883@avionic-0098.mockup.avionic-design.de>
 <20120928110712.GB29125@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20120928110712.GB29125@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:kxgwIH37TI2nbPuzM8z+c7VXiAyATcV7KZF9rxtbsAF
 gBZ3FGP+ply12SPavPwhVIBQeV8IFD/VhnHQX8LOAL6eXQZ4uj
 98rEVKu+sOyZ7EiCv1VLM22S3exZleoBRkM3SbAJZxwB6KSdbs
 hzysU/ZqrQrfKJUinT8t9JeYo25xIWEf5ZyYbyy5fGOxSHtAbe
 H+YM7+SD8OWWoid6XaH40S2GgwRIevcq+b3u5xblRLtKQppB+K
 uN4bWJGW+FgWL88SnphUnakfp1xSXa+OWRpS2hdCky/NFmvREb
 o90qlebRDinTtgT0AcS0SPJREW+NSkEIK15BMph0HBlxEi/bfh
 XPSWPx+i3X6hNqSMuIJu3cIkbw2dSWogrG9y5rWNX3rMSDx3XS
 E0TiW8+5N3/tKkuxqlSJ6phliSIfOzIrbsi0uL49t5TgGwev1g
 6Bn4+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 28, 2012 at 12:07:12PM +0100, Mel Gorman wrote:
> On Fri, Sep 28, 2012 at 12:51:13PM +0200, Thierry Reding wrote:
> > On Fri, Sep 28, 2012 at 12:38:15PM +0200, Thierry Reding wrote:
> > > On Fri, Sep 28, 2012 at 12:32:07PM +0200, Thierry Reding wrote:
> > > > On Fri, Sep 28, 2012 at 11:27:28AM +0100, Mel Gorman wrote:
> > > > > On Fri, Sep 28, 2012 at 11:48:25AM +0300, Peter Ujfalusi wrote:
> > > > > > Hi,
> > > > > >=20
> > > > > > On 09/28/2012 11:37 AM, Mel Gorman wrote:
> > > > > > >> I hope this patch fixes the bug. If this patch fixes the pro=
blem
> > > > > > >> but has some problem about description or someone has better=
 idea,
> > > > > > >> feel free to modify and resend to akpm, Please.
> > > > > > >>
> > > > > > >=20
> > > > > > > A full revert is overkill. Can the following patch be tested =
as a
> > > > > > > potential replacement please?
> > > > > > >=20
> > > > > > > ---8<---
> > > > > > > mm: compaction: Iron out isolate_freepages_block() and isolat=
e_freepages_range() -fix1
> > > > > > >=20
> > > > > > > CMA is reported to be broken in next-20120926. Minchan Kim po=
inted out
> > > > > > > that this was due to nr_scanned !=3D total_isolated in the ca=
se of CMA
> > > > > > > because PageBuddy pages are one scan but many isolations in C=
MA. This
> > > > > > > patch should address the problem.
> > > > > > >=20
> > > > > > > This patch is a fix for
> > > > > > > mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2=
=2Epatch
> > > > > > >=20
> > > > > > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > > > > >=20
> > > > > > linux-next + this patch alone also works for me.
> > > > > >=20
> > > > > > Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > > > >=20
> > > > > Thanks Peter. I expect it also works for Thierry as I expect you =
were
> > > > > suffering the same problem but obviously confirmation of that wou=
ld be nice.
> > > >=20
> > > > I've been running a few tests and indeed this solves the obvious pr=
oblem
> > > > that the coherent pool cannot be created at boot (which in turn cau=
sed
> > > > the ethernet adapter to fail on Tegra).
> > > >=20
> > > > However I've been working on the Tegra DRM driver, which uses CMA to
> > > > allocate large chunks of framebuffer memory and these are now faili=
ng.
> > > > I'll need to check if Minchan's patch solves that problem as well.
> > >=20
> > > Indeed, with Minchan's patch the DRM can allocate the framebuffer
> > > without a problem. Something else must be wrong then.
> >=20
> > However, depending on the size of the allocation it also happens with
> > Minchan's patch. What I see is this:
> >=20
> > [   60.736729] alloc_contig_range test_pages_isolated(1e900, 1f0e9) fai=
led
> > [   60.743572] alloc_contig_range test_pages_isolated(1ea00, 1f1e9) fai=
led
> > [   60.750424] alloc_contig_range test_pages_isolated(1ea00, 1f2e9) fai=
led
> > [   60.757239] alloc_contig_range test_pages_isolated(1ec00, 1f3e9) fai=
led
> > [   60.764066] alloc_contig_range test_pages_isolated(1ec00, 1f4e9) fai=
led
> > [   60.770893] alloc_contig_range test_pages_isolated(1ec00, 1f5e9) fai=
led
> > [   60.777698] alloc_contig_range test_pages_isolated(1ec00, 1f6e9) fai=
led
> > [   60.784526] alloc_contig_range test_pages_isolated(1f000, 1f7e9) fai=
led
> > [   60.791148] drm tegra: Failed to alloc buffer: 8294400
> >=20
> > I'm pretty sure this did work before next-20120926.
> >=20
>=20
> Can you double check this please?
>=20
> This is a separate bug but may be related to the same series. However, CM=
A should
> be ignoring the "skip" hints and because it's sync compaction it should
> not be exiting due to lock contention. Maybe Marek will spot it.

I've written a small test module that tries to allocate growing blocks
of contiguous memory and it seems like with your patch this always fails
at 8 MiB. Given the default size for CMA allocations is 16 MiB I thought
I should try increasing that but it doesn't make a difference. The
allocation still fails at 8 MiB.

Maybe that'll give another clue.

> Failing that, would you be in a position to bisect between v3.6-rc6 and
> current next to try pin-point exactly which patch introduced this
> problem please?

I can possibly do that but probably not before sometime later next week
unfortunately. But I'll see if I can find some time to double-check that
some older linux-next version works and that my memory isn't failing me.

Thierry

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQZYxsAAoJEN0jrNd/PrOhJUIP/34Md+W2RYZgJlYTI2Zno+oo
uQxSLEuDb+D1MUhZxMnTFVK7y18nT36DM5HVzEvPYgGL02/HPOkMPTXBW3E3pweo
2sqmNT8r3cPWNVCj21IwxuIQDO76JFfIRpTLQpxzh+JpWS6utDPA8EWW3VNZz4Zb
FZUfgfDwhCDXykN13p4amvBWy/A75xXf/WsGx0IleB6qicrl6IFcxYDmESl2Ohud
WP9bpTh5Re/2OJypUHdOvHnVAnQiUhmd4ubgZpp4NQj6VOz34GDECgQzsg/y4Luv
t9QjKc/7Taw59vtedyA6hS93wWzkUPyv05G3pMlwtswSG2OiRG9MOYB+V6nf6Lhj
s5rLYFyFNF63JDBK5VzvtAyGmsvVT6fEjQ3U1Mhu3wz89TUwPfdg8i+CCdJ/g1PL
8V4Fb9rv128m+RTgZgl03RV5ZgekF8TTTRwIfLMMudUPFZvEE8qHKrdJ5ft0d0RS
LzBpt4DUMF+xqGcPe6fI+yg624iOJ7iDk6sB57ubIz5zEuo4xYHwUmY16pTAVgIR
/6ENXSpYmZFsnGlwI9ImFU/nhljZQdmsWMDE93ATEgdjMmg2Ql+YNLHnnY0faV6B
MS61G6ktCHyYF4Y2uVBS30+uvdsm3BDm3Vga6Sn0KonYqGmoD5BZ7GzXd9z9Q264
YBqdSFF2KRgVHhI/Lu/F
=iu9m
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
