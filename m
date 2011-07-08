Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1GHLoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 07:44:34 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33593 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341Ab1GHLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 07:44:32 -0400
Date: Fri, 8 Jul 2011 14:44:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com, kishon@ti.com
Subject: Re: [PATCH 0/6 v3] arm: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
Message-ID: <20110708114425.GI4820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1310122965-23612-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="169fIVB/g4KxrKrw"
Content-Disposition: inline
In-Reply-To: <1310122965-23612-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--169fIVB/g4KxrKrw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin, Paul, Tony, Benoit,

On Fri, Jul 08, 2011 at 04:32:39PM +0530, Keshava Munegowda wrote:
> The Hwmod structures and Runtime PM features are implemented
> For EHCI and OHCI drivers of OMAP3 and OMAP4.
> The global suspend/resume of EHCI and OHCI
> is validated on OMAP3430 sdp board with these patches.
>=20
> V3:
> Set MSTANDBY_SMART_WKUP for idlemode of usbhost
> Rebased on top of git://gitorious.org/omap-pm/linux.git
> Branch: for_3.1/3_hwmod_fixes
> commit 213ca8a3a8d73225f2f5304ab3a68c6eda0f6d1b
> Author: Benoit Cousson <b-cousson@ti.com>
> Date:   Fri Jul 1 13:52:03 2011 +0200
>=20
>     OMAP: hwmod: Move pr_debug to improve the readability
>    =20
>     Sligtly move the pr_debug at the top of the function
>     to trace the entry even if the first test is failing.
>     That help understanding that we entered the function
>     but failed in it.
>    =20
>     Move the _enable last part out of the test to reduce
>     indentation and improve readability.
>    =20
>     Signed-off-by: Benoit Cousson <b-cousson@ti.com>
>     Cc: Paul Walmsley <paul@pwsan.com>
>=20
> Benoit Cousson (1):
>  arm: omap: usb: ehci and ohci hwmod structures for omap4
>=20
> Keshava Munegowda (5):
>   arm: omap: usb: ehci and ohci hwmod structures for omap3
>   arm: omap: usb: register hwmods of usbhs
>   arm: omap: usb: device name change for the clk names of usbhs
>   arm: omap: usb: Runtime PM support
>   arm: omap: usb: global Suspend and resume support of ehci and ohci

can we get the hwmod stuff in this merge window now ? It has been
rebased on Benoit's branch.

--=20
balbi

--169fIVB/g4KxrKrw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFu2ZAAoJEAv8Txj19kN1SkEH/25Q7+5P+BwuzM+zcdG6FVSL
X8DmlJC26DcKsmXM94lutjCA0kjE1NIQxqN1l5C2186gnw2qxjaMKIigVHJny+gH
v2B3g4NLsEUr41cZ+14COKCebRtKyZk5gP0lOD6+X12pqptj1fFia838bEqsjhUI
Vkd6UbAvgb9LCcfN8+P5xPOAP7D06oUI5NziWhPi4+ei/tgxFrJse5Bk4HgNS55l
nLuV09cuO8QSGHuvExW65I16EXbmlK/dX9XsPUhsuQp5gLLlciuvpwgQjfE6NW0x
R5RF7F5IzvKt20CcWDjMa3t+G1qMbLhH6Ck0+vb+WyGNRAO+P5XXGwoH6EDwDSY=
=7qWe
-----END PGP SIGNATURE-----

--169fIVB/g4KxrKrw--
