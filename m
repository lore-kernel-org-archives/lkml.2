Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2HWGa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:30:56 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:53808 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744Ab2HWGat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:30:49 -0400
Date: Thu, 23 Aug 2012 09:26:47 +0300
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
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [PATCH v2 00/13] OMAP Serial patches
Message-ID: <20120823062646.GC31295@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345551371-18862-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Content-Disposition: inline
In-Reply-To: <1345551371-18862-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 21, 2012 at 03:15:58PM +0300, Felipe Balbi wrote:
> Hi guys,
>=20
> here's a series of cleanup patches to the OMAP serial
> driver. A later series could be made re-implementing
> DMA using the DMA Engine API. Note that for RX DMA
> we could be using RX Timeout IRQ as a hint that we better
> use PIO instead ;-)
>=20
> All patches were tested on my pandaboard, but I'd really
> like to receive Tested-by on other platforms.
>=20
> After this goes in, I'll probably try to get UART wakeup
> working again and only after that look at DMA.
>=20
> Changes since v1:
>=20
> 	. improved commit log on patch 9/13 (formerly 10/13)
> 	. removed patch 2/13
> 	. added a new patch switching from spin_lock_irqsave() to spin_lock and
> 		spin_unlock_irqrestore to spin_unlock
>=20
> Retested with my pandaboard, UART continues to work:
>=20
>  # grep -i uart /proc/interrupts
>  106:        124          0       GIC  OMAP UART2
>  #  grep -i uart /proc/interrupts
>  106:        189          0       GIC  OMAP UART2
>  #  grep -i uart /proc/interrupts
>  106:        255          0       GIC  OMAP UART2
>  #  grep -i uart /proc/interrupts
>  106:        321          0       GIC  OMAP UART2
>  #  grep -i uart /proc/interrupts
>  106:        387          0       GIC  OMAP UART2
>  #  grep -i uart /proc/interrupts
>  106:        453          0       GIC  OMAP UART2
>  #  grep -i uart /proc/interrupts
>  106:        519          0       GIC  OMAP UART2
>=20
> cheers
>=20
> ps: if anyone knows a better test for UART, let me know.
>=20
> for convenience of anyone testing, patches are available on my git tree [=
1] on
> branch uart
>=20
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git uart

Well, it turns out we found a small issue with one of these patches. We
have already fixed the isse. Will re-send the series soon with a few
more patches added. cheers

--=20
balbi

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNc0mAAoJEIaOsuA1yqRE6xMP/1nf5I87THiMnv+a0J5TCqcv
bKIBNoRR0gp/PbPPHmwIboEhcyu8+Qu26Jvdch8usAsGFffGrOBOoDyKlFNE0879
mDS02bCPZU7N7ncHlcfaWL19kQVcDGaAT3akGhYly1yI9RnANvZVzWxsiVMv1skA
BQ51VB+r1fGnwRumj7v/F3T3fkMh+X6/cSW1HN65mrN7ng3cdY/RculuYWvKrLhU
9qMBIy37PSCOZjrwIoY1rmxioUsWpuF6FWfxsD9/WIj0lOuJevggqcuyMBnatLHy
EB3KffJC+5Ru1oVQzDYc6XgbXrGh/DBZ0SJAR6fwEh9RFW27KfLw+YgL1IU0pSgk
vtNWMCJotpwpvNReHRLIJi4ulv88SxiciqFqWUCMfhkXqV/ngnSU5SOIX/YPWyNl
qLGQVPiJ+BRI/TuXQBc6E2DgciFd5oUVEdp3wwI1lzEM2+B+JWkCYplPC4G5TzgG
7Vyc8LuwgeO2T18CNrUhVw76RYd9Yh+CpW2nfPStzYT4rKzVf+g0+aF92viPcm3s
ay7IVHHBbDUvWPjiQ97phX8hei8HUTNzTN1iGer2zZgsw75QmYGxTAH0CyUsu7kc
HynuIXoJsRHJULqT/8MsbVmbEPGVgxkavkWCCP23IS3M0I+8S8/Qh8WSSQZ6ChJ8
rVNGcPMB1DwO91wtBLFP
=zppC
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
