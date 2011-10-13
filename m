Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab1JMR72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:59:28 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:45634 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932176Ab1JMR7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:59:25 -0400
Date: Thu, 13 Oct 2011 20:59:21 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, paul@pwsan.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 5/5 v14] omap: usb: host: Replace usbhs core driver APIs
 by Runtime pm APIs
Message-ID: <20111013175921.GN28290@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1318319531-20476-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hD6P3ib1XCFtz2ni"
Content-Disposition: inline
In-Reply-To: <1318319531-20476-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hD6P3ib1XCFtz2ni
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 11, 2011 at 01:22:11PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>=20
> The ehci and ohci drivers does not use the APIs of the usbhs
> core driver; the runtime pm APIs are used for clock
> enable/disable. Since usbhs is parent platform device of the
> ehci and ohci devices, the runtime apis indirectly uses the
> usb hs core device as input parameter to for clock functions.
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Reviewed-by: Partha Basak <parthab@india.ti.com>

I'm not sure who should queue this one. Alan, maybe ?

FWIW:

Acked-by: Felipe Balbi <balbi@ti.com>

as an extra comment, this patch has a very deep dependency on the hwmod
conversion patches which come before this. If those aren't applied on
the same merge window, we will have a non-working *HCI driver on OMAP.

--=20
balbi

--hD6P3ib1XCFtz2ni
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlyb5AAoJEIaOsuA1yqREhlwQAI1ERq45siI5di45Gt/E+OHg
htcgCnnHlDCXVsTlNp4cnD6o+wFheJghEPc8D9YdvGKYwqtvsiSCRSz9R+M/2tVs
XUzr7XjBlL2Lv4GoNVI6gtP6Hixdk6KSeWUAuW8WpMUfVWdrFhXIoJ2/csj0WHtU
mBzbEdwy+ew/SNoKbDCa3zvu47hbrcW1czJTbXZKdtZOKLLMC1yNVAK9mqKGHXjA
ALmeVv+utPZBKQGLrftRAbUYh6f9dZ4q0i346YwI8nWAJq0ROgM+6cxlzyUgZozv
wDNWOiTWuz07sdogUQj2xN8ImGL0VBD0/LML80Vu4w/D9kdmREyDNJ+RVotGXNSj
16mNjq8AEqKL6X9QnJ3DxGN8qVLZzKdzY8IdD7UZbpgGJojCYQdBMfgKD4OToK2k
+IM3WOFlIaHunTMrGmiMPgCK0havS6KJtqh3/A/O0VQiPO8xjdBwrZ2ym4XhPysY
cRac2AXDMnV4XiyPyl4Q5tYNfOVf5pLmv0oKjjw3xpuA/U7PdsEYlMEHU9fo6zZU
+FsXLkA5uLq6z6ctqLQmbxDebd3o6+/ibyrZv+6hlfEesc2y5P/UODRn5W+jMj1z
Gvr8QxDB+p6PR3sVvS1esdQzNAC4LWQQQTTX7XvpfjkIepJxrZlirBzbn3H60MBO
5JXavfdXawO0V47KWZvq
=1iJT
-----END PGP SIGNATURE-----

--hD6P3ib1XCFtz2ni--
