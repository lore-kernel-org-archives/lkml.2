Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1FIJq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:46:28 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:58990 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756911Ab1FIJq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:46:26 -0400
Date: Thu, 9 Jun 2011 12:46:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 9/10] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110609094618.GJ13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
 <1307360469-29120-9-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a0kvDU9Y5772Ejco"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-9-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a0kvDU9Y5772Ejco
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 02:40:53PM +0300, Tatyana Brokhman wrote:
> This patch adds SS support to the dummy hcd module. It may be used to test
> SS device when no (SS) HW is available.
> USB 3.0 hub includes 2 hubs - HS and SS ones.
> This patch adds support for a SS root hub in the dummy_hcd module.
> A new module parameter was added: is_super_speed. When set to true, a SS
> root hub will also be registered and the connected device will be
> enumerated over the SS root hub. The default of this parameter is false.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

applied to gadget branch, thanks

--=20
balbi

--a0kvDU9Y5772Ejco
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8JZqAAoJEAv8Txj19kN13FgH/1R+UvOevqMvdlC7VpnL1j23
bdYV+pskJGIc00zA84YG6yizoI2zNqafbcDmFlIrCzvTSfGyNVWzyx8NocXRW535
hSTn/SCpXKzc5vNbB5K+6IDSducHqFsh1gj0kLod4D3l4lwqXqJTlFi2Fa9K/zpA
rt/rrxIdyo6FctIRbo53joi2hYLK6M9+YsvqFT6DUOqqmGV2k0jLftZTgN4Q/usi
iMLsoFAxo2UJut7L9m8iPQFNcHL94DWFv0XkvnQpmR1Sws6hhFaCrTj2y8WqSFjY
4mOSLisLh6OYXoj5lQhHhtA2ZbYEA3lojipeJsFLAz0laelFVHhVqTPz58f/tdA=
=S5cw
-----END PGP SIGNATURE-----

--a0kvDU9Y5772Ejco--
