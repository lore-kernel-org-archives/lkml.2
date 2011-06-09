Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab1FIJpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:45:31 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50250 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab1FIJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:45:28 -0400
Date: Thu, 9 Jun 2011 12:45:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org, Maya Erez <merez@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 6/10] usb: Add streams support to the gadget
 framework
Message-ID: <20110609094521.GG13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
 <1307360469-29120-6-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AeHkbrJcO8giN/MO"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-6-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AeHkbrJcO8giN/MO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 02:40:50PM +0300, Tatyana Brokhman wrote:
> This patch defines necessary fields to support streaming for USB3.0.
> It implements a new function (usb_ep_autoconfig_ss) to be used instead of
> the existing usb_ep_autoconfig when working in SS mode and there is a
> need to search for an endpoint according to the number of required
> streams.
>=20
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

applied to gadget branch, thanks

--=20
balbi

--AeHkbrJcO8giN/MO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8JYxAAoJEAv8Txj19kN1gpUH/RQW0X3vAZRPgLeNk58B4/AD
jXqtqQ/erVp7jx4GH4Q5tNv9qINC0Gn/E2F+4s56oCl+wus+3r0hLyvfnB168gHL
oZu7erH8+llR7PLVnHyJuq0NO7jwL3Bo+8PKyKAzFekKzMJQKul9jLeCmPUIyP73
ZeIGw/sRfXGyv2ZaEAG9fxNTJDU11DTm9W1BqelIJjlvhZfNbH+upbh+RlOIeuVc
wtBfZwdRZRRKtDfSFDdYPFxmx0zzGufkHiCpfl6R1bPAYPRVluaU8uWmXuMXL4B0
kr4qm8PYnJ06efFARZzHhf4704XrmRb8qvwvJ+sm2QaYk3Ji1k6ons691LEM+PE=
=+NvB
-----END PGP SIGNATURE-----

--AeHkbrJcO8giN/MO--
