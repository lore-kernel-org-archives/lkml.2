Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1FML5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:57:35 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:38351 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab1FML5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:57:33 -0400
Date: Mon, 13 Jun 2011 14:57:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'open list:FREESCALE USB PER...'" <linuxppc-dev@lists.ozlabs.org>,
        "'open list:OMAP USB SUPPORT'" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] usb:gadget: use min_t() macro instead of min()
Message-ID: <20110613115723.GN3633@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307877290-26672-1-git-send-email-tlinder@codeaurora.org>
 <20110613092438.GK3633@legolas.emea.dhcp.ti.com>
 <03b901cc29c0$6538e970$2faabc50$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="prC3/KjdfqNV7evK"
Content-Disposition: inline
In-Reply-To: <03b901cc29c0$6538e970$2faabc50$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--prC3/KjdfqNV7evK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 13, 2011 at 02:52:34PM +0300, Tanya Brokhman wrote:
> > On Sun, Jun 12, 2011 at 02:14:46PM +0300, Tatyana Brokhman wrote:
> > > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> >=20
> > I need a sensible commit log for this. Why do we need to change all
> > min() to min_t() ?
> >=20
>=20
> Actually, Alan asked me to make this change in one place in dummy_hcd. I
> wasn't aware of the min_t macro before that. So when I searched the code =
for
> other places I found quite a few and just thought that it would be "nicer"
> to use min_t() instead of min() with casting.=20
> So we don't "need" to make this change. Everything works as is. This patch
> only makes the code look nicer, nothing more.
> I can elaborate the above in the commit log if you want.

Yes, that's what I need. The question was supposed to be answered by the
commit log ;-)

--=20
balbi

--prC3/KjdfqNV7evK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9fsjAAoJEAv8Txj19kN1lLUH/R6eacJNptNb0Du6BBS4XTKU
gd4jqe3RWib8Yhe7q395ySJM/i9IgAgAc3sfRAO+jQWQdHr54ZusbRRB9Xor+OJk
uaS0dK+h2s2iDuKW5uXziVJgxeJBBGP1ehSgRErEqbB26XO3pUC5Zv5xpRVtDhv8
c/kNE/v1NhpTvoncCS7NvYMyoaamK5WCE0EKGlbhquMXI/rL7FCrG+uXXcVVinXu
8SPTYyoRiOGEgeHkaz3+qThM9RTy7dtsKfy3DOgyr7dYQ6yHLusHJ6mdja3PcJng
ufEQTsLdEPZxxlrcyUvq0xnBjN2JsnY2ApmLq2oMlQBi9/fp8KCPZYd88ry8bWI=
=IYJJ
-----END PGP SIGNATURE-----

--prC3/KjdfqNV7evK--
