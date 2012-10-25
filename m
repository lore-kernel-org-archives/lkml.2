Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935800Ab2JYQCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:02:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45501 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933842Ab2JYQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:02:45 -0400
Date: Thu, 25 Oct 2012 17:02:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: arizona: Correctly report when AIF2/AIF1 is
 underclocked
Message-ID: <20121025160243.GN18814@opensource.wolfsonmicro.com>
References: <20121025141413.GA31418@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/TUrtqMIkCP4YtJm"
Content-Disposition: inline
In-Reply-To: <20121025141413.GA31418@opensource.wolfsonmicro.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/TUrtqMIkCP4YtJm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 25, 2012 at 03:14:13PM +0100, Charles Keepax wrote:
> In the interrupt handler for an underclocked event, whilst checking for
> the source of the interrupt, AIF3 was checked twice and AIF1 was not
> checked. This change correctly checks the AIF1 underclocked bit and
> reports the correct error messages for all cases.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--/TUrtqMIkCP4YtJm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiWKcAAoJELSic+t+oim9YYgP/1GHLTVGgRODz2+1RXHOBv0O
n7plc7v1NEnExwcsc9g3N0XByNSL8gO9PF9vgCiFSFUjoYLuHsr3D6dpqwbtjXkv
GngyaDTI5ycOzAhQR+eTFHPMyzuTKSVD0DYrckFmetSid4YpRDmm6vvgjXJZbO6y
c0JJvSJRFTDr3KopD166tq08TJeH221MMQfLotBiGAwcsIZBALBJshaWgDnpAetV
AcpTzj06IjT+pWNjLDGT1PU7iDAXBxy7bKV47XXPH5slLAVj2o+5fCHMGiyOGPc3
0EDy8jMFCacFOA9/1p7HOmC5tywgztc15u44BTK0NjGp81FagyXlrjMvBmu+xay4
2Zb60Y0LxXh7JjO7BGj3fgvpwcZpBNQiN6YLJKTtnaINlAz3QcwCYH+Xtf8dmH5U
vMnOUxTvZRUPKw6c8o7DS9/tBQ06MTpkWrqrq4BorMDYBeUb7f406pZCKQpvzvxw
0PrXMhrlRMHA2NQEwUoKsF3pp6eZQAWdtCn2ZIFoC1z03k2RnVQfWc3I1eVVltQc
ZeqwgA2XyTpMskWv/Fl6MLA2IgNNnKVTDnGhi5HqtDT748h/HXqGanUrx8wyz823
oJxnh5S+0mkcJIkZPv5f9m0o2qYXbYMsCZwjA2hHop6PPo1vlsff9CSaGW9L7Vxy
DO/XocoJC0W+cDoP2DsU
=V4aa
-----END PGP SIGNATURE-----

--/TUrtqMIkCP4YtJm--
