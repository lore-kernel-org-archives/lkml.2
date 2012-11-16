Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2KPOCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:02:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44498 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2KPOCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:02:53 -0500
Date: Fri, 16 Nov 2012 15:56:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/6] dma: dw_dmac: check direction properly in
 dw_dma_cyclic_prep
Message-ID: <20121116135625.GA18920@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1353074360-1903-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1353074360-1903-4-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 03:59:16PM +0200, Andy Shevchenko wrote:
> dma_transfer_direction is a normal enum. It means we can't usually use the
> values as bit fields. Let's adjust this check and move it above the usage=
 of
> the direction parameter.

why above the direction parameter ? You need to explain why ? Is it just
because 'it looks nicer' or have you found another bug triggered by
that ?

--=20
balbi

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpkYJAAoJEIaOsuA1yqREeL4P/2T6A6JsmJnyjwlwA9ErgQ2P
EPFQNFnigIuxW6sntur39lv8AgfMmplQ+OZ+YSvuPHDpPJk1Pe9UzeGImN93av/r
Fzwfx0VMUmS2CaVsN1l8qIP1r8PnwnUlBJtKlDqTXwRHWKXf+L9WvpaXEVxHhhKy
vTYiv4vpUXvMTbpmdcMFX/3m/oLaZdJgWMMScDLUNLBbPfzmM+O/tEzDV+Dzs3lx
ZCZbFVxCQJlgdXFm6pCW2GG+5V5kukZIe4c0DZTsvJg3yg+y8I1oYVCziQ24SKYL
t8VGVyVKKIKzybPAqknlmKnxkKsFq1oBW+KVFBAx+y9SDmhMGjn+Jbc0GyCh7t9g
HKWv+EU6xYo+KABQY8LZ5HgudAJ9YDnUSkCW3TPYdUvmhC0V9U63oOQB6ZMn164/
sKBJGwyiBKHRCZausi7FadiLUYrdcj29x0HVjWPmJ2hKNZ+c+3XngpIUztLY1G45
EzQfaVPidE5P91fcUsn5OP7KhHdjZGD5Wdal4rsa1dofqKs2HmUhAOueDbKS7DLY
nJR4HIy9A2wayhi/Y1kkqUwVy/yLP8PQfaSZlUHse0VvjK8RszF9E1kQfP7xPEb0
lDk6K+H2Talg4f8V3AVUuN5a853ZwQjuEF6PB60I5BePq9a3U5FyBY/Mo+SnrTDg
4gqBBfrbKMX3mdSeeq4n
=m5oC
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
