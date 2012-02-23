Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2BWUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:09:59 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:48320 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756806Ab2BWUJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:09:58 -0500
Date: Thu, 23 Feb 2012 12:09:52 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Anthony PERARD <anthony.perard@citrix.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>
Subject: Re: PCI: Add PCI_EXP_TYPE_PCIE_BRIDGE value
Message-ID: <20120223120952.6d9915a1@jbarnes-desktop>
In-Reply-To: <1329841330-14902-1-git-send-email-anthony.perard@citrix.com>
References: <1329841330-14902-1-git-send-email-anthony.perard@citrix.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6RJqChPfqE5W3V+LIdZqRV="; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6RJqChPfqE5W3V+LIdZqRV=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Feb 2012 16:22:10 +0000
Anthony PERARD <anthony.perard@citrix.com> wrote:

> Signed-off-by: Anthony PERARD <anthony.perard@citrix.com>
>=20
> ---
>  include/linux/pci_regs.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> index e41a10f..4b608f5 100644
> --- a/include/linux/pci_regs.h
> +++ b/include/linux/pci_regs.h
> @@ -391,6 +391,7 @@
>  #define  PCI_EXP_TYPE_UPSTREAM	0x5	/* Upstream Port */
>  #define  PCI_EXP_TYPE_DOWNSTREAM 0x6	/* Downstream Port */
>  #define  PCI_EXP_TYPE_PCI_BRIDGE 0x7	/* PCI/PCI-X Bridge */
> +#define  PCI_EXP_TYPE_PCIE_BRIDGE 0x8	/* PCI/PCI-X to PCIE Bridge */
>  #define  PCI_EXP_TYPE_RC_END	0x9	/* Root Complex Integrated Endpoint */
>  #define  PCI_EXP_TYPE_RC_EC	0xa	/* Root Complex Event Collector */
>  #define PCI_EXP_FLAGS_SLOT	0x0100	/* Slot implemented */

Applied, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/6RJqChPfqE5W3V+LIdZqRV=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRp0QAAoJEIEoDkX4Qk9hu9UP/RaFaroT0qaz8vn9kpXPvOs8
1OVSJ3Z0WkhBJ8aM1u1158CGomyIfZ4TikqO/u8Tg7Q7tX5FaG8OH+TvFYFzwsR3
Iwle86BPSDI3KMD00C4yEm8Z2b7BhEK9Ji5QgfyeN7IuhYqE+HaQBz7OxPTkmGN1
0A6DSL1KFtoQIcv5SFMX4+8BoqIh1xmffM+u7MTH64D9YQmRsaan8Grzjjhw5VrM
Fs7NRsDHd6hv7cW6Et5162RuknLe0+wi7N+9Wm1qKjz4QS4L/sa4L8RxGWp8gJVw
fz5+7jTijriioP57ZP3Tesw1qjGIjPUwKrs0e05J/taRP2llJ/qHwnGhpjJpyJk7
XmrayCPyRKUok+YqmlPwkYn1QUlyFNqcJZqS6W5mQgywrnGfssuhPfm2iua7p10k
we+JPQwvLWoTEsmPGKfgLccwO3bCal8zZGBOA9Z6TZUZ4k0UmhNOrNbqoCVxtuIU
2NlZofKqmuMuzh/S2yVWl9QYzh9eguO3TRfOHiGqqYBncUHSO0w4hib5lKdno2wl
QRczHY7apMvPTB16pEYDtriRhDubw0OsvMcP8H0yp7e/Sk2iuQ+od9MlhT1LgR9y
fTk7RctN8ExPdsA1WiUaLU2OLBcz+k3jJMOVYTRy+X8jcys2PMeq4UztQIWYuPUt
oEkliWdJejcSNiUyk29o
=dY5a
-----END PGP SIGNATURE-----

--Sig_/6RJqChPfqE5W3V+LIdZqRV=--
