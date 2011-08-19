Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1HSLkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:40:07 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:53632 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab1HSLkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:40:04 -0400
Date: Fri, 19 Aug 2011 14:40:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com, tom.leiming@gmail.com, toddpoynor@google.com
Subject: Re: [PATCH 0/5 v6] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
Message-ID: <20110819113953.GM23101@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313753646-29089-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VnOTrGv5LmZxna7m"
Content-Disposition: inline
In-Reply-To: <1313753646-29089-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VnOTrGv5LmZxna7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 19, 2011 at 05:04:01PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>=20
> The Hwmod structures and Runtime PM features are implemented
> For EHCI and OHCI drivers of OMAP3 and OMAP4.
> The global suspend/resume of EHCI and OHCI
> is validated on OMAP3430 sdp board with these patches.
>=20
> these patches are rebased to kevin's pm branch and
> usbhs latest mainline kernel patches
>=20
> TODO:
>      - Aggressive clock cutting in usb bus suspends
>      - Remote Wakeup implementation using irq-chaining

what happened with V5 ? I didn't see any comments to that one. Please
start adding your changes here too.

--=20
balbi

--VnOTrGv5LmZxna7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTkuJAAoJEAv8Txj19kN14r0IAKZq4Dkl+FKC7Bxg3/KP8HVv
wVgVXaZ5CedUYfoud07lug/xWf8IlfZtx5YYQZ6TzNfEmvkTA6v44AQqHXtxTGj4
5WFIdrIvBNfWPCoBkzJTu9UBThuQGVH81qOsNDsA+6calXLAkdNB3zzMoLWL/u5f
xXiwkRjeyRT6Db3EG5IPZxBROWlaV/fqFJCqX+lIvtvZzY+7U5/vwafqu2CZk9hb
KNdNkTOevr6KT5NQl7ZHQt8VOJy4MO1SlGDbrbN/hWhGHVu08yqtQkEobyePqV5+
Q8ed2Wmmeglb43CqXh6I+lyVOq8gCLTYyKeMclE05WEbi01xx3bqcVT6VCIUk5o=
=zlnZ
-----END PGP SIGNATURE-----

--VnOTrGv5LmZxna7m--
