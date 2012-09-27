Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab2I0Hri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:47:38 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:48031 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755514Ab2I0Hrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:47:36 -0400
Date: Thu, 27 Sep 2012 10:42:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 3/7] dmaengine: dw_dmac: remove CLK dependency
Message-ID: <20120927074236.GI12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o7gdRJTuwFmWapyH"
Content-Disposition: inline
In-Reply-To: <1348731121-2515-4-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o7gdRJTuwFmWapyH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 27, 2012 at 10:31:57AM +0300, Andy Shevchenko wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>=20
> This driver could be used on different platforms. Thus, the HAVE_CLK depe=
ndency
> is dropped away.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 677cd6e..df32537 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -83,7 +83,6 @@ config INTEL_IOP_ADMA
> =20
>  config DW_DMAC
>  	tristate "Synopsys DesignWare AHB DMA support"
> -	depends on HAVE_CLK

as is, this will break compilation of any arch which doesn't set
HAVE_CLK.

--=20
balbi

--o7gdRJTuwFmWapyH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZANsAAoJEIaOsuA1yqREslIP/iYBYD+UNrBnJFikYIrgqoNj
SpNiNmlSj+4OatywFgo3/68myYgq8ZP8GP6sLMjXxVy/B7DSQt/HJ7Zs6Xc0pZtJ
gQ0RUC6SmGO8cDAs1jrpjduh4f4e7HwxIfaNIxl/N2DQ5lv0g2qmge2d/vNtKfDB
UFdpcxW8ZsH5RlLFTdK/2F1XwaYFjMy3xthWDCeN370RjMDht3JRNmFME6jXjZaC
eJXGstUEIeXKBi/vLw4yAK3n7XBmCE5ro+iFAR6VaxAI4/MQTyROtaThR2JDGfVl
D4NsRm6jqBUe1LZqaL9VzW+7NcbuUAypOevjGw2kvvBf62jaRzrP+V/sr5F2ylyT
Wlv7a7e5yFKkv1N2MG1xu3LGlUK1ezq1skORovPhXrex0fVolBt4+Q0VHzSdjUsT
CF+Afqim2beUeqgp0tOs1YyHU0mSqwykOYxTB3as1rJlehSXmhXTzZY6CwUHda27
1ko5DqYQspqtGQFapy3iewa0kg2QyuNmRoBcFDW5WNArQNfuXndZADIfZ7bowVyJ
t2+4tZFkhrS7yqAykcYb6IeV6Wq76syevPQsqqirPojZ4RMym3/kGzkJ6+8ZBzkB
uf0I32V88gzJBzrcMA8PzCDXt5lR2Nwck/dDPnV0w+LWD/iv1h8+u5zXjsOQpNe9
u/iZzDIuemTDSLUnjvUE
=Fxpw
-----END PGP SIGNATURE-----

--o7gdRJTuwFmWapyH--
