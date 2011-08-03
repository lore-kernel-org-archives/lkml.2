Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab1HCNQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:16:34 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50376 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746Ab1HCNQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:16:29 -0400
Date: Wed, 3 Aug 2011 16:16:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] usb: musb: ux500: replace missing DBG with dev_dbg
Message-ID: <20110803131625.GK11080@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312374137-10629-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mPOSj6iWmtyhwOMz"
Content-Disposition: inline
In-Reply-To: <1312374137-10629-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mPOSj6iWmtyhwOMz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 03, 2011 at 02:22:17PM +0200, Per Forlin wrote:
> From: Per Forlin <per.forlin@linaro.org>
>=20
> ux500_dma.c fail to compile becase DBG has been removed from musb_debug.
> Use dev_dbg for all prints.
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>

does this affect any stable release ?

--=20
balbi

--mPOSj6iWmtyhwOMz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOUopAAoJEAv8Txj19kN1j2EIAJbPKuouNKYVPB/XqosfLrFI
sPbn7eKygorehY9FH6A+dJSaxmK4t6YDYqxRI1JmMoZZNsp3sHvdtGv4HOlmcKqu
ezfJXBfpnJ3/BfRQct3bMIyn5eIpz2I1Xbdk8DPqwZELc63xVrkWIuz0pu+D/2v7
sQEX+e6OyHE7fwq0WdrEdL5wc0UlHeEyhBCflqDEC9YrIAWTOkxAeBHUaINXgZNg
CeyMH3Kb94gF10bjcmhBju4C9kEhBsa90h58cxbni/KXGOL6O0SwuHdn52C2T+h5
g0TrXtyllgu88KzxYettCirpOorSsve07/KaXnXspP/5+DeS8dTec8JfJNvs7Gk=
=lPw/
-----END PGP SIGNATURE-----

--mPOSj6iWmtyhwOMz--
