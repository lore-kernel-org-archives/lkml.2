Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2HCNfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:35:46 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:39850 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405Ab2HCNfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:35:44 -0400
Date: Fri, 3 Aug 2012 16:32:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 07/11] drivers: usb: twl4030: Add device tree support
 for twl4030 usb
Message-ID: <20120803133214.GI8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-8-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rmm1Stw9KgbdL9/H"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-8-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rmm1Stw9KgbdL9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 30, 2012 at 02:39:56PM +0530, Kishon Vijay Abraham I wrote:
> Add device tree support for twl4030 usb driver.
> Update the Documentation with device tree binding information.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

I think this also doesn't have dependency on the rest of the series and
I could take this upstream. Right ?

--=20
balbi

--Rmm1Stw9KgbdL9/H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9LeAAoJEIaOsuA1yqREM2AQALYEumGV8k2vIkkCRRX7zGAq
kVE/XpWZqDCyD07kguMPO3wnLMuC2JI4rAY0rBDUVygPOYt1l//RbDrtnNnGw0/4
gA9rKVJAT+ic0Tksfhb4vYI4Mgal/31hp3Q7rqr5/7bYxr+wWR+NMR3srIhHiyWC
eW7Y2JlHRUXoXzky0VPj/wd1vmBbAykrG8tWmcrTVG8Oz3wYhxFifGlyATCAEopJ
vho3aUzc88yws2rEyNV91xnysblOgyBoB/U27vHq1QGzsbbRGAZhujrCo3nJ1A25
M9bVmsakjkvPz4KWcE4h6qq61omrTSjWg/0HPdCWvDWQzAmKbOuE4FwJ9/xS9KFd
AwbPyq+HsKqsoG+EGZAOtJrWCo/imLbmEUlr4dR8ISfkObpxWeDP8fDbU2L7CKhX
UaNN703LssRIcNnhyiz1NaxUI4RqCNJhiYnyZ6JezUlS9yCgtDXaWMhOdvjhh+Zm
vd47PGpB+X4mZilUNeX1s0yCv20Ml/FeC5o1XuTvAN7GhXI0D/j1UHDr8Eien1hw
o2lVUJxQ5l26kXhi6P4KrHeWSUY+OmmFC4fyMQk6ppveiJAY38he6OzFecU/iN6y
MIc+vNKtvTnRKG3ourZ8TD2iDvZi3rL5Ae8KnruJFsKlV2wWxltWtmbzGAJkslOT
+MqgoBU7Hl1lWCC9CHxv
=YUpb
-----END PGP SIGNATURE-----

--Rmm1Stw9KgbdL9/H--
