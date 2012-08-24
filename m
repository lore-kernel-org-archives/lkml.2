Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab2HXKoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:44:54 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:43879 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757816Ab2HXKov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:44:51 -0400
Date: Fri, 24 Aug 2012 13:40:47 +0300
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
Message-ID: <20120824104045.GC5172@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
Content-Disposition: inline
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Forgot to Cc greg initially, my bad

On Thu, Aug 23, 2012 at 01:32:40PM +0300, Felipe Balbi wrote:
> Hi guys,
>=20
> here's v3 and hopefully final version of this series. A whole bunch of new
> patches added but the good thing is that now I had another engineer's hel=
p to
> test, so he's got his Tested-by in all patches.
>=20
> Changes since v2:
> 	. Added a bunch of new patches
> 	. Fixed a problem where we would always return IRQ_NONE even though we
> 		handled IRQ
>=20
> Changes since v1:
>         . improved commit log on patch 9/13 (formerly 10/13)
>         . removed patch 2/13
>         . added a new patch switching from spin_lock_irqsave() to spin_lo=
ck and
>                 spin_unlock_irqrestore to spin_unlock
>=20
> Alan, if you prefer in pull request form, here it is:
>=20
> The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad=
92:
>=20
>   Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git uart
>=20
> for you to fetch changes up to a29230f14d8466c9b8c25171715378bf52189453:
>=20
>   serial: omap: enable RX and TX FIFO usage (2012-08-23 09:25:16 +0300)
>=20
> ----------------------------------------------------------------
> Felipe Balbi (20):
>       serial: omap: define and use to_uart_omap_port()
>       serial: omap: define helpers for pdata function pointers
>       serial: omap: don't access the platform_device
>       serial: omap: drop DMA support
>       serial: add OMAP-specific defines
>       serial: omap: simplify IRQ handling
>       serial: omap: refactor receive_chars() into rdi/rlsi handlers
>       serial: omap: move THRE check to transmit_chars()
>       serial: omap: stick to put_autosuspend
>       serial: omap: set dev->drvdata before enabling pm_runtime
>       serial: omap: drop unnecessary check from remove
>       serial: omap: make sure to suspend device before remove
>       serial: omap: don't save IRQ flags on hardirq
>       serial: omap: optimization with section annotations
>       serial: omap: drop "inline" from IRQ handler prototype
>       serial: omap: implement set_wake
>       serial: omap: make sure to put() on poll_get_char
>       serial: omap: remove unnecessary header and add a missing one
>       serial: omap: move uart_omap_port definition to C file
>       serial: omap: enable RX and TX FIFO usage
>=20
> Ruchika Kharwar (2):
>       serial: omap: fix sequence of pm_runtime_* calls.
>       serial: omap: unlock the port lock
>=20
> Vikram Pandita (1):
>       serial: omap: fix software flow control
>=20
>  arch/arm/mach-omap2/serial.c                  |  15 +-
>  arch/arm/plat-omap/include/plat/omap-serial.h |  47 +-
>  drivers/tty/serial/omap-serial.c              | 808 ++++++++++----------=
------
>  include/linux/serial_reg.h                    |   4 +
>  4 files changed, 330 insertions(+), 544 deletions(-)
>=20
> --=20
> 1.7.12.rc3
>=20

--=20
balbi

--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQN1otAAoJEIaOsuA1yqRENScQAIfdOpoN+cViqL+fghwV0BcL
ePvUgKNvO71eBhIKDZ1kIxuPtyrv/kBRToVbrS9Deni35lngp3xuBwQEfwcsB29z
xzXtlQsA9fUDoCe5EI2z1kQAVH2+aMyY/7qMOQ5cKWeTfOs5yAqJK0M/RkRhYs0i
o8I06uCcu2ozK6/zaiwr8Y1bjZd/uEOlB9TxWcxHfhqCHKJyLjqsbbibXv/Nj2nb
YkOQRWyAh68bxLdqEX/NbWuwCFb6+EiVQQD0m8ZMsZ2KZLW2W5WZtak+72bvFhlZ
anS+d3X4Bb7RygefNYEZC3qK5a+abFHpZUkoydcDTVoEtib3fuwv6KNesFdhlKLr
lRctOMv+LYga8oeAx8tpSoMOeNVMH23seS/ZnjP0ZqgiGHQOVXdYH4MfbdJZSRrh
9GiJJMoD7t7kQ/kObRN6WsbHclhOm1WU/rbVkj9E6BOxS1zm0XLkvUFVdm8qCumK
EwO/sMDQd1Kx9if7JO2KHMrv6ER9WhcbvXdSMQ5XDwN75O6HqPy0WCS2cGX4tc1D
sVg+Pa2CyTJWVrgIPnL80z5gIYILm90diJB6H5pn0DrH8Yok7FFB2tQ7yr6Z6MEs
L6qEnUXDoYojcWEwHmvIRim994hAUcKqpH8audrYz6NtC7+KX1R5Iq14ZlIU2FWI
3aFZrkgDXxlvqr1OF+sT
=6rEj
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
