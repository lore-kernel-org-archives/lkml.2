Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab2HUL62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:58:28 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:46322 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754650Ab2HUL60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:58:26 -0400
Date: Tue, 21 Aug 2012 14:54:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [RFC/PATCH 02/13] serial: omap: always return IRQ_HANDLED
Message-ID: <20120821115426.GC10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345540555-24359-3-git-send-email-balbi@ti.com>
 <20120821125005.235926e0@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9uNR01GrImESOVvg"
Content-Disposition: inline
In-Reply-To: <20120821125005.235926e0@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9uNR01GrImESOVvg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 12:50:05PM +0100, Alan Cox wrote:
> On Tue, 21 Aug 2012 12:15:44 +0300
> Felipe Balbi <balbi@ti.com> wrote:
>=20
> > Even if we enter our IRQ handler just to notice
> > that the our device didn't generate the IRQ,
> > that still means "handling" and IRQ, so let's
> > return IRQ_HANDLED.
>=20
> That looks wrong - you'll defeat the stuck IRQ protection. If we didn't
> cause the IRQ then we are IRQ_NONE ?

that's true. I'll drop this patch from the list. My bad.

--=20
balbi

--9uNR01GrImESOVvg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM3byAAoJEIaOsuA1yqREUO0P/AtKnPqH9TaUDrx6vMjdGugP
0SsYwJTMErf9Ipt5bBvTzwLBixOnPu8yVJBayjoxQ/lvlSdeTLNQoo/oLYTG6oVI
v5Fxi7sAG+FJQ9Kwiw6PC4sWUSLhA5wVmvIABqYVmYfIi1OewM5oOT1m/ER4QGnw
2H4Hn1b7v7nsIagpsMkKkBJ1SqCoyQbq8S9VAC80IhVUwpglSTX7SiimxTiPKqwY
MJ/5c/0KgD3GwXYvZ1iFeuNYnvO1E9XBpFVb8kGUc5PtUl4HRsaFiEd5uCsfxxzL
13k0CnQR/vap1lzThBdzAvS6P3ZvekovMGB0mrZzalfJFU2P3reUDjI3jcF8uf/C
sVyxEzymzQXV/BtIKmg0hPAzUBJd6CPoJqZ2j1TjszREPKDAe9qJ77pwKu+C+Tmt
ZmOe/DOiXJuxFjcSsHEO3Fz4l5Q5tZDg3rCrlhjhIaW4pNCKYf9ChC4ABIQA30ES
uJfRKNzwa0hGa8FqmWXaDBllgsNLGZ7tFJLxpY9kQROnZXmadSOxKzr5XRUhEntS
ttkQjAqh8bKSMRr60PrLe1xEl+3g3fQX97vtYuJTdclnlaBZo6brkQLANaTJtzTn
gYcpG1rbkOt563SORWOoQphgIbWGyreyaimzdIjhe4QjOQhkKFA9ojGBLufspqEi
zbtNiNMCyFGdHrDnXDM8
=ezih
-----END PGP SIGNATURE-----

--9uNR01GrImESOVvg--
