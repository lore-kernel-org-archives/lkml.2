Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2HCNdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:33:21 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:41876 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397Ab2HCNdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:33:16 -0400
Date: Fri, 3 Aug 2012 16:29:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 04/11] arm: omap: hwmod: add a new addr space in otg
 for writing to control module
Message-ID: <20120803132945.GF8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 30, 2012 at 02:39:53PM +0530, Kishon Vijay Abraham I wrote:
> The mailbox register for usb otg in omap is present in control module.
> On detection of any events VBUS or ID, this register should be written
> to send the notification to musb core.
>=20
> Till we have a separate control module driver to write to control module,
> omap2430 will handle the register writes to control module by itself. So
> a new address space to represent this control module register is added
> to usb_otg_hs.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

this should come before previous patch, right ? Otherwise we will try to
ioremap a resource which isn't passed down to driver. No ?

--=20
balbi

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9JJAAoJEIaOsuA1yqREnXAP/36/NQV5OtS2pQIu3629edXj
vL1asGoL52Ns5ncESoak4aJrPADSxEkgY97aeIJwAQ5bwxVOAiHGJ4kuBH5JNLsM
vbpn6QAViGPfZhX6ODTezG7CwFNsXXnW54pmLCZPH+RDcXJ3H/jfRM/pG4IE2eBb
YwkdnBjZ5TjnMeCfltwm7hxk8SUYnBE7yyeT7aihL3DXy1WHsWWaurWvHJiObJMl
+rCAk9J3IojLLbiVZlcU4Wljk62cpl3zud759qIryUvaz6mrbKCJTIbaWd4z9PJc
T++l6TMHOuLTBXakEq63qNn2Waik6t045r968oju4+iu0N6k5KeuNcOyZ1LK/Nfd
6XPRSGSwOMD/stT2e8BZWT7hpfY+F9TXih+6EDa2iVVhW5S3U1wG1YPjcIPQ7nWC
2xF3vzi4vK0RuiW97HrgAms7fI6oSPdvMbSgFTi4mqbFeA4GJ3Ti/+1EBlYssyOO
9YLtoj+8ck07vsLCOd2Pq+UYe8vdvW3HP/YRGy/BZzMarPKn53enpmZZq48jzo4T
atdtYj7e2xXuUUxffFEsSexkJOJSV3MV3830e5dN/yO082JtWFpaYqVizlizKKzN
3z3V9iSnWJJfBIqQKrsG+UCsBSLRr1RSeioIbqvf7d8Yc9btdTWRx/zHl3Ol7WDW
fQATjUc017aYWYyjHyG0
=2xOM
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
