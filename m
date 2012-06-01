Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab2FAIa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:30:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58531 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758785Ab2FAIaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:30:22 -0400
Date: Fri, 1 Jun 2012 09:30:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, alsa-devel@alsa-project.org,
        lars@metafoo.de, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v5] sound/soc/lapis: add platform driver for
 ML7213
Message-ID: <20120601083018.GH24139@opensource.wolfsonmicro.com>
References: <CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
 <20120524100742.GH5361@opensource.wolfsonmicro.com>
 <CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com>
 <1337941231.1580.19.camel@vkoul-udesk3>
 <20120527221956.GB25019@opensource.wolfsonmicro.com>
 <CANKRQnhwkhGUHi6WQhw-sRJuKari3SLcipCJXVp27OZ29=Vxkw@mail.gmail.com>
 <20120530121449.GI9947@opensource.wolfsonmicro.com>
 <CANKRQni4uqQJ99ycOScHmn-g1kz2_XH7ePL+n1taG5jAbDSubw@mail.gmail.com>
 <20120531104538.GA2666@opensource.wolfsonmicro.com>
 <CANKRQnjdiV+e=N+n_ZP04jmCAhxKjgZ+wab+anbgO+VJPNo=PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Content-Disposition: inline
In-Reply-To: <CANKRQnjdiV+e=N+n_ZP04jmCAhxKjgZ+wab+anbgO+VJPNo=PQ@mail.gmail.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 01, 2012 at 05:13:45PM +0900, Tomoya MORINAGA wrote:

> > Linus' tree, or mine.

> Sorry, I couldn't find.
> Is your saying Linus's tree this ?
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> However, any ASoC driver doesn't use cyclic DMA's.

$ grep CYCLIC sound/soc/soc-dmaengine-pcm.c=20
	dma_cap_set(DMA_CYCLIC, mask);

--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPyH2BAAoJEBus8iNuMP3deKEP/3Djm3B9K0mBDLBCvjU71CO+
m+i+NmZupFqbBxkxz8SkfGv9ajX+0UPNdYY6vThQG4ggtyc/A1ejnWuO6vL6S9UK
3GMJTFvHjg3BhBCC11xdyJpVBUNVdMXrhyDtbDe3P80V4h/mfZETgSMLmL6dIHyn
KMb+MA+j5LLh7vnigMobp8z0Zra8eZzmrktSYL3dFNlg+GhEa+ixfBW98FOH2sU+
1ITcaBxRvWardBWRKoDzR1PsZcZ7ajLtJ4K5mTbVTM3kfNkkHcNlNFW5YTfxyo8b
9APANxysU8BWEvMxXgDCaxMoZjYoC2dh2cGXzQaQA+y9vKnkECwJhF9IF+RNfyhE
uNv33avnmCeqw0swTFdSqDbEg3UExekhK6yHPgtVkLCsEzxpqg5QstGDpdCYYuGA
wS5p3vwAuui+YofkQYTApgT7cg1XFFLFtO/L9JBLH1BNkhZXVNGfTRJs1b6EXqJc
NQvNp3ap6ZoJfi1DzSdfc267FyGRFijmk2+HgNMbxDV9rpqkauZO04shQlwaI/Bz
h9zkB4lds8irdKrotRhFQLfZ4QUzQjXGsNf+dpmMIdtKRorCUm6Dbg5fUNffmRr7
xyk6FB0qFnka34OdAw/QtcCdRJT6487N87ckCC9o+amMNl/n62oF8A9mQYV4W839
Iputd6WtIwY5brZtIiuq
=NduQ
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--
