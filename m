Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1HCNSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:18:00 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:43323 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764Ab1HCNRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:17:54 -0400
Date: Wed, 3 Aug 2011 16:17:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] usb: musb: ux500: replace missing DBG with dev_dbg
Message-ID: <20110803131749.GL11080@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312374137-10629-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yQDbd2FCF2Yhw41T"
Content-Disposition: inline
In-Reply-To: <1312374137-10629-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yQDbd2FCF2Yhw41T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2011 at 02:22:17PM +0200, Per Forlin wrote:
> From: Per Forlin <per.forlin@linaro.org>
>=20
> ux500_dma.c fail to compile becase DBG has been removed from musb_debug.
> Use dev_dbg for all prints.
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>

applied, thanks. Let me know if this should go to stable and I can make
sure of adding stable to the Cc list.

--=20
balbi

--yQDbd2FCF2Yhw41T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOUp9AAoJEAv8Txj19kN1EpYH/0AcPqsQNLQE1VB5bXhRhXbT
KwYUTveY8oDH0Y/m/OgYWc9exn+lCUpF1w7p8PHMrV6KM7GKJN0dcQTnhmY50Ofu
bmJvEFLvXWmS7ZRGP3IJNASx8YHWIUHVzmEn0QqgWe2y5tC7voDkApn4oDoF9K3W
5kLmFhbXxrdvkavfeWAJUMLdFhoSwdS/oOFuTDrrWi3jsKwqwR2ZJnsfMiPW/Kib
H1ytKbE8WF7X9qXNmEb3FIh8fqHQlcKDY3wgbN8c/q+6Rde8+58a0nDxK88z+Vfk
33Mc8QDOoRb2MCxrKVrqMJY63MRSIjATwaBZ4aj9G58j0tHXwp/Fd2hJj27MOWs=
=yiVF
-----END PGP SIGNATURE-----

--yQDbd2FCF2Yhw41T--
