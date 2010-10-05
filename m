Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0JEAqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:46:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36594 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab0JEAqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:46:30 -0400
Date: Tue, 5 Oct 2010 11:46:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "N.P.S." <napohybelskurwysynom2010@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Message-Id: <20101005114621.d64561cb.sfr@canb.auug.org.au>
In-Reply-To: <20101004161600.8cdf4e0c.akpm@linux-foundation.org>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com>
	<4CA4D61C.2010909@gmail.com>
	<4CA4E76E.1050602@gmail.com>
	<20101004161600.8cdf4e0c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Oct_2010_11_46_21_+1100_BL_QKNOyE/atVn6q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Oct_2010_11_46_21_+1100_BL_QKNOyE/atVn6q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 4 Oct 2010 16:16:00 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Thu, 30 Sep 2010 21:39:26 +0200
> "N.P.S." <napohybelskurwysynom2010@gmail.com> wrote:
>=20
> > Here is a patch that removes duplicate includes introduced in -next and=
=20
> > -mmotm
> >=20
> > --
> > Zimny Lech
> >=20
> >   arch/arm/mach-omap2/board-rx51-peripherals.c           |    1 -
> >   arch/arm/mm/flush.c                                    |    1 -
> >   arch/xtensa/include/asm/coprocessor.h                  |    1 -
> >   drivers/mmc/host/ushc.c                                |    1 -
> >   drivers/staging/ath6kl/os/linux/include/ar6000_drv.h   |    1 -
> >   drivers/staging/batman-adv/soft-interface.c            |    1 -
> >   drivers/staging/bcm/headers.h                          |    1 -
> >   drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c       |    4 ----
> >   drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h       |    1 -
> >   drivers/staging/brcm80211/brcmfmac/wl_iw.c             |    4 ----
> >   drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c     |    1 -
> >   drivers/staging/rtl8712/drv_types.h                    |    1 -
> >   drivers/staging/rtl8712/osdep_service.h                |    1 -
> >   drivers/staging/westbridge/astoria/gadget/cyasgadget.h |    3 ---
> >   sound/soc/fsl/mpc5200_dma.c                            |    1 -
> >   15 files changed, 23 deletions(-)
>=20
> Removal of duplicated includes is a somewhat dangerous thing.  If
> someone else says "hey, there's a duplicated include" and then fixes
> it, and if this patch removes the other include then whoops, we broke
> the build.  This has happened before.
>=20
> So I'd ask that you redo and resend this patch shortly after 2.6.36 is
> released please, so I can get it into mainline quickly thus minimising
> the opportunity for such breakage.

Or could it be broken up and sent to the appropriate maintainers?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Oct_2010_11_46_21_+1100_BL_QKNOyE/atVn6q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMqnVdAAoJEDMEi1NhKgbsS/AH/3mEYkOS3n6XH4B0J1Ms3IZh
lfylhZ4lB2mdO+X8KBfTNt+TkaRQBriajD5B7PdF6ZFlywIqBewYHvGfRoPjQ4SK
QsZKOUTUgsR6/hXvWR3X8PxeYf7nQEAcfclRcvBIBLIx82gS5z85v/b2S127q6G5
t4AT8O9EA7x6zss8TLCTCwvGKH4lEVTgsuTOq+Kgdv6zAUP7RbEUQ+dGytq7nvhX
Dauifo0HKrhvUbmizrGr1G1t5+oqZQfPsdYBLVAiwl4EU+Ir23XR3k7kYccSWY39
FgyxIzkcxnMktI8oE/FR3GU2X5PywghJjf1XScpjOSCYKNVZzzytEJIRy+AvTL8=
=7PT0
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Oct_2010_11_46_21_+1100_BL_QKNOyE/atVn6q--
