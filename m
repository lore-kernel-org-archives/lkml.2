Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2LNPrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:47:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49668 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2LNPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:47:45 -0500
Date: Fri, 14 Dec 2012 17:40:30 +0200
From: Felipe Balbi <balbi@ti.com>
To: Paolo Pisati <paolo.pisati@canonical.com>
CC: Felipe Balbi <balbi@ti.com>, linux-omap <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>,
        Robert Nelson <robertcnelson@gmail.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
Message-ID: <20121214154030.GD18233@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355389980-5532-1-git-send-email-paolo.pisati@canonical.com>
 <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
 <20121213094715.GA1916@arwen.pp.htv.fi>
 <20121214153943.GA3306@luxor.wired.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Content-Disposition: inline
In-Reply-To: <20121214153943.GA3306@luxor.wired.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 14, 2012 at 04:39:43PM +0100, Paolo Pisati wrote:
> On Thu, Dec 13, 2012 at 11:47:15AM +0200, Felipe Balbi wrote:
> > On Thu, Dec 13, 2012 at 10:13:00AM +0100, Paolo Pisati wrote:
> > > Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> > > Tested-by: Robert Nelson <robertcnelson@gmail.com>
> >=20
> > please read Documentation/stable_kernel_rules.txt, you'll see this is
> > wrong.
>=20
> you mean that i should have waited for the commit to hit Linus's tree bef=
ore
> cc-ing stable?

No no, I mean that before you SoB you should have a:

Cc: <stable@vger.kernel.org> # v3.x v3.y ...

Something like the commit below:

commit 041d81f493d90c940ec41f0ec98bc7c4f2fba431
Author: Felipe Balbi <balbi@ti.com>
Date:   Thu Oct 4 11:58:00 2012 +0300

    usb: dwc3: gadget: fix 'endpoint always busy' bug
   =20
    If a USB transfer has already been started, meaning
    we have already issued StartTransfer command to that
    particular endpoint, DWC3_EP_BUSY flag has also
    already been set.
   =20
    When we try to cancel this transfer which is already
    in controller's cache, we will not receive XferComplete
    event and we must clear DWC3_EP_BUSY in order to allow
    subsequent requests to be properly started.
   =20
    The best place to clear that flag is right after issuing
    DWC3_DEPCMD_ENDTRANSFER.
   =20
    Cc: stable@vger.kernel.org # v3.4 v3.5 v3.6
    Reported-by: Moiz Sonasath <m-sonasath@ti.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>


--=20
balbi

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQy0huAAoJEIaOsuA1yqREMUQQAJOjquBR3LJ8aDeik52K4ej+
BEBY00obnBmfUnH91O1GYkhu2EVxSxknJiJtlgbyYNm2NMpPsFJpn4qUtErvdJs8
cEdzZmFF3DDklpalqOAgLytbOUHi2dZAn9fvDqgHyS+1yHa2u5icUOlmSkS46aXU
AH4YiOtJYnJf3lzZiZMmOvoDSs9N3C6dyQ9abMr1Z/SSdGfql4XCDZq8ccdiu3vt
DiuldMLD95rpSaeeFocfWkXyFV3ssvPjh284Kf9JfWfqazkX52XXRHjZ6WG9C2Ar
39JQKKRdU/P2EMA4+eEhpNqDK/dy9ma3myjahITzbF5rRoKzuhqDDXrAZaG9sqPn
PzcRxPQPHFwHPtsjsKgqbm0Zpwv7FZ9/NNiPRJX3yxd9p/CNmCVwA1xEivfldDIk
XOKusE5G8CaHhiDNenag2F2DQDa5EaDDiXbV9iqpZgBW5q+ijAPnv8N8FQ2lcjfc
WtZQ0fS9c6vbAzP5I89tsbvTlBF8bDHf/POo1p/OSpSnV80L5BtZzR0AE9hX1XTQ
9Kr+dfdcfITafMPJjrMNqrewseKOHPJS6nM3hLhQOFL+Sz2gFIt1sFHel2VsuuIR
bJEo5YX0TdBCqECosNdtchG4SxSlfq6+cadWfGwsw3kdW4E1JW4Z5q9QVLw7zpOs
Cw+XOu47g/sQSWGX8tQB
=pUyD
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
