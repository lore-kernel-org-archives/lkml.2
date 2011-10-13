Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1JMRcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:32:13 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44510 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499Ab1JMRcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:32:10 -0400
Date: Thu, 13 Oct 2011 20:32:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, paul@pwsan.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH v14] mfd: omap: usb: Runtime PM support
Message-ID: <20111013173204.GL28290@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1318319609-20522-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="64LDleNqNegJ4g97"
Content-Disposition: inline
In-Reply-To: <1318319609-20522-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--64LDleNqNegJ4g97
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2011 at 01:23:29PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>=20
> The usbhs core driver does not enable/disable the interface and
> functional clocks directly, These clocks are handled by runtime pm,
> hence instead of the clock enable/disable, the runtime pm APIS are
> used. however,the optional clocks and port clocks are handled by
> the usbhs core.
>=20
> Dependency:
> This patch is dependent on this series:
> [PATCH 0/5 v13 or latest version] omap: usb: host: Runtime PM preparation=
=20
> for EHCI and OHCI drivers.
>=20
> Validation performed:
> The global suspend/resume of EHCI and OHCI is validated on=20
> OMAP3430 sdp board with this patch combined with the series:
> [PATCH 0/5 v13 or latest version] omap: usb: host: Runtime PM preparation=
=20
> for EHCI and OHCI drivers.=20
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Reviewed-by: Partha Basak <parthab@india.ti.com>

oops, acked the wrong one before.

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--64LDleNqNegJ4g97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlyCUAAoJEIaOsuA1yqREMcIP/36RG/eFVlU6A0r4yjYu/HPo
4HspeALtkxVEpSitdYej/d51K/0V0B4kr0wAY1P4/AbJ127X6wegFYZK9U8H6oqH
rpgnHY24CjSZospRIwX2xc3xTZvm/RG93EKbE0OhiEcm7RF9f2p7X8WDwTKgNtLz
0f4JijDwi+RzlbG0twRU+Fq57GjMHg8YRHNZr1fZ7hNVRLEhv3wdJivdGhAYO0yk
SbiKFZgcGtDKBPHkt5hCURarB2PZPnVyhIyS2F+eTCe+6d960zoN1vv9Zr7Az4O7
dIL9jg4iEfpwJr4kjZf9OtNoV+b6W48A0Ojl5HVgo5Lo2B6ynJLtmqYKv76c5nEK
psyNwWhuXfPJl7LFZUZbcbs5ATjsjXlKbSZpEzPWbdEZh4eduh8gfmRbSj+frr1S
uYXCJ+HQ0AIQ1yq3gRP+OU8G/+EWspMw7+bO9YKDBO/F6FsHDzhFf+5xZHYjfOp9
UA5u5KS3hNcmVueyOITAZSJBTHoOIG2OIZC+ZyAd8Nh82HL+nL8Rpi0vBDPt/uqh
fiLsfwxx44eW2+Ie9gALuu8XAoOPYQKBfkBvoyxqZobS2XDZOSM7/rjg+wuHQazT
8aml3tvYgPnOqnbcds0a/QknY+haYQYU/KWmyJOYPJ0TWkDcrnuebJaCKFgWv4UU
rfUJrwZcIPI9DhOIBS3X
=lGfW
-----END PGP SIGNATURE-----

--64LDleNqNegJ4g97--
