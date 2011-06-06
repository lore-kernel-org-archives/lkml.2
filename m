Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab1FFNwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:52:31 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:42933 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785Ab1FFNw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:52:28 -0400
Date: Mon, 6 Jun 2011 16:52:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com
Subject: Re: [PATCH] mfd: omap: fix the crash during omap ehci or ohci driver
 initialization
Message-ID: <20110606135221.GG12242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iAL9S67WQOXgEPD9"
Content-Disposition: inline
In-Reply-To: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iAL9S67WQOXgEPD9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 07:12:19PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>=20
> Oops are produced during initialization of ehci and ohci
> drivers. This is because the run time pm apis are used by
> the driver but the corresponding hwmod structures and
> initialization is not merged. hence revering  back the
> commit id 7e6502d577106fb5b202bbaac64c5f1b065e6daa
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

Reported-by: Luciano Coelho <coelho@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--iAL9S67WQOXgEPD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7NuVAAoJEAv8Txj19kN15m8H/RtGep/nynV1lG+CKlGRdD7X
dgoAp31JtY1nfJmA7fB8cxQe/t20GwmT1DkaZHnyF1qfEPVZeUF/A+UAp0g+k6BT
C0x+ZfweSrBrxL6pP1QyYP3auLVH6O5ltCwEZmRxA+6ksGF5bcuSgrvJC6hbn7JR
k6GQuoJgVGjIOtEPdFDw+Qe5pkLrrdh9qIP8dcm9XMPUA8NGZD/tlizDLNWMkU7y
cIiwhZJ855Beu4V61x08Khyz2S/AZK/qtU9r4TX7jQk7q8KUslaheeDVkGC/7nkE
gC7QX+nXU0DzJW6492FtMm42zYjANzPudoiNKPfCRe6vyp7jziZ2u8TausT/RKI=
=2zXV
-----END PGP SIGNATURE-----

--iAL9S67WQOXgEPD9--
