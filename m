Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2IDLuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:50:06 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:40366 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756817Ab2IDLuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:50:01 -0400
Date: Tue, 4 Sep 2012 14:45:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 00/23] OMAP UART patches
Message-ID: <20120904114540.GF12901@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
 <20120824104045.GC5172@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <20120824104045.GC5172@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 24, 2012 at 01:40:47PM +0300, Felipe Balbi wrote:
> Forgot to Cc greg initially, my bad

a gentle ping on this series so we don't miss it for v3.7 merge window.

Greg, let me know if you need me to resend.

cheers

> On Thu, Aug 23, 2012 at 01:32:40PM +0300, Felipe Balbi wrote:
> > Hi guys,
> >=20
> > here's v3 and hopefully final version of this series. A whole bunch of =
new
> > patches added but the good thing is that now I had another engineer's h=
elp to
> > test, so he's got his Tested-by in all patches.
> >=20
> > Changes since v2:
> > 	. Added a bunch of new patches
> > 	. Fixed a problem where we would always return IRQ_NONE even though we
> > 		handled IRQ
> >=20
> > Changes since v1:
> >         . improved commit log on patch 9/13 (formerly 10/13)
> >         . removed patch 2/13
> >         . added a new patch switching from spin_lock_irqsave() to spin_=
lock and
> >                 spin_unlock_irqrestore to spin_unlock
> >=20
> > Alan, if you prefer in pull request form, here it is:
> >=20
> > The following changes since commit d9875690d9b89a866022ff49e3fcea892345=
ad92:
> >=20
> >   Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git uart
> >=20
> > for you to fetch changes up to a29230f14d8466c9b8c25171715378bf52189453:
> >=20
> >   serial: omap: enable RX and TX FIFO usage (2012-08-23 09:25:16 +0300)
> >=20
> > ----------------------------------------------------------------
> > Felipe Balbi (20):
> >       serial: omap: define and use to_uart_omap_port()
> >       serial: omap: define helpers for pdata function pointers
> >       serial: omap: don't access the platform_device
> >       serial: omap: drop DMA support
> >       serial: add OMAP-specific defines
> >       serial: omap: simplify IRQ handling
> >       serial: omap: refactor receive_chars() into rdi/rlsi handlers
> >       serial: omap: move THRE check to transmit_chars()
> >       serial: omap: stick to put_autosuspend
> >       serial: omap: set dev->drvdata before enabling pm_runtime
> >       serial: omap: drop unnecessary check from remove
> >       serial: omap: make sure to suspend device before remove
> >       serial: omap: don't save IRQ flags on hardirq
> >       serial: omap: optimization with section annotations
> >       serial: omap: drop "inline" from IRQ handler prototype
> >       serial: omap: implement set_wake
> >       serial: omap: make sure to put() on poll_get_char
> >       serial: omap: remove unnecessary header and add a missing one
> >       serial: omap: move uart_omap_port definition to C file
> >       serial: omap: enable RX and TX FIFO usage
> >=20
> > Ruchika Kharwar (2):
> >       serial: omap: fix sequence of pm_runtime_* calls.
> >       serial: omap: unlock the port lock
> >=20
> > Vikram Pandita (1):
> >       serial: omap: fix software flow control
> >=20
> >  arch/arm/mach-omap2/serial.c                  |  15 +-
> >  arch/arm/plat-omap/include/plat/omap-serial.h |  47 +-
> >  drivers/tty/serial/omap-serial.c              | 808 ++++++++++--------=
--------
> >  include/linux/serial_reg.h                    |   4 +
> >  4 files changed, 330 insertions(+), 544 deletions(-)
> >=20
> > --=20
> > 1.7.12.rc3
> >=20
>=20
> --=20
> balbi



--=20
balbi

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQRenkAAoJEIaOsuA1yqREBVcP/is/q8bsHKbEbwVcFSYN1nlM
eJe8OjNgmo+gRA5bQtLTTkXoV8SXsO2ipBDN8hjczGbTc33eErklLe0uVYD3LgQN
Qh74/voD5n7KBHXt8PhMSLQjglMIXoWqP+qCum6ZRvNsguzkqbt3D2LCfeNwSg/d
sELZOX+ajkDo4cUQ+SHTrmWUFSKpt/kdD3KxGZUnsChVpY/BxEsLPq9wZjIyk9BS
CtoY8yLDhA2zxcEYv12GchoDAKEPIBKkEt42lDBXNLz6kDLRiDhYK7YYpL9x12Nw
GJwQodRZbSJkqNlO6VgGNy+SccLa8Frz1LLYyUA/lzxXQIoEzmNBLcFKRWgWr1kv
Tag0Qj/Nh8Ie7oe1j9UzJgEojYArRqtosKQ36jiKWxK6iP3EloRE6jBO+c3oUL8u
OxLR/FOYGdWencWwdAkdCWCNsUgVX5LMlpyTYBfxNR3kEvANFtoUPo6koF5XRHzK
DuzsUpd19C22jmbc7ohToZZzKIvPnsB/D0ZbfH0ZeQVwvk2iuWKcG6yhOV4oDh2G
RXGP8rTPXj+daUTYQfL3aBwu71dOq2Uy2ymd2jvKDjDlev9JY3HP/cSC4lInw2aD
3VW6v3T5QM9MDhVxW5QBRD+MXZ58ma42a6HD48w9ltpX8DNOxTxy/NiZzyQ0+9z3
dP3lEps0ybJcwgTKX73J
=zWYQ
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
