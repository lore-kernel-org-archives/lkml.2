Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1FONHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:07:37 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:50211 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab1FONHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:07:35 -0400
Date: Wed, 15 Jun 2011 16:07:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND/PATCH 0/2] trivial patches
Message-ID: <20110615130724.GN471@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305589270-5389-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+2GlJm56SCtLHYlr"
Content-Disposition: inline
In-Reply-To: <1305589270-5389-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+2GlJm56SCtLHYlr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2011 at 02:41:08AM +0300, Felipe Balbi wrote:
> Hi all,
>=20
> following patches avoid double semicolons at the end
> of module_init/module_exit calls.
>=20
> Felipe Balbi (2):
>   trivial: add missing ; at the end of module_init/module_exit
>   init: drop trailing semicolon from module_init/module_exit

ping... ACK ? NAK ?

--=20
balbi

--+2GlJm56SCtLHYlr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+K6MAAoJEAv8Txj19kN1u/8H/2RIpR66B66Fx2iDVSXsFNwv
Ap5BK6kk7/CV+KWD9YeKXCL9aFKdu//Z2dQnSCP1UPnQ3yUCfyvTCT2BbEQsyCe2
2h6vS2klnIBvG0jhFC4LgeWRvjGZJOnq43+/EUdUBwcU0n2fHY/az3thR6/DPrLn
lT1gIhXyKvq7yrHHCKpvWGIbcEAUpRgg8B82i/F7DQY5BS5ISUdGbz+1gFuZpjEs
M/4NAJO/vBHdTGBeyV+5RoME9HCHS78lwiX5m+M9LPE25BH6Y+7q1TWiCUANHy21
YOqTOUcxh21rT9b+etCTIuSRh1tO/hgQ+1m8aa9lXQJpCeXK5KrwcmCBbPzlO0Y=
=jBBK
-----END PGP SIGNATURE-----

--+2GlJm56SCtLHYlr--
