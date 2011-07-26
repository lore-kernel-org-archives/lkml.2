Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1GZOx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:53:26 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43219 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab1GZOxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:53:21 -0400
Date: Tue, 26 Jul 2011 17:53:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Felipe Balbi <balbi@ti.com>
Subject: Re: [Patch] fusb300_udc: remove unused function
 fusb300_ep0_complete()
Message-ID: <20110726145315.GE32582@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <CAM_iQpX84cR+9s3nL-p5V3a=bQgmRwJ5jhWpLY0WNS3TO8f8LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qsoMWdMv/ifdm7CC"
Content-Disposition: inline
In-Reply-To: <CAM_iQpX84cR+9s3nL-p5V3a=bQgmRwJ5jhWpLY0WNS3TO8f8LQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qsoMWdMv/ifdm7CC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 17, 2011 at 05:53:39PM +0800, Am=E9rico Wang wrote:
> It is not used, so just remove it.
>=20
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---

applied, thanks.

(next time, please put patch inline on the mail rather than as
attachment ;-)

--=20
balbi

--qsoMWdMv/ifdm7CC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLtTbAAoJEAv8Txj19kN1UeQIAKafmGMRwiq7hIF5uM8jJOzD
WVmWeXUzX4ZvP7QG4G2hadZwX9k7920DyurGtQmJWoAsFy4/IQs7+bLzGyg1EE/B
DgoQOzKwlgVg04N+niBNwegv5q5y0JrE4QSUtxDP+wZhl+P4xY+nkxbFvAnPJy5N
yuOG5hZVvQ3jCcWyeEVxenpIs8LgjDiqLN/ajnrHtoba3zPuG39f2/n1cZ9Kg/4s
w8bZzuqWxeoPqFSoYLKeuPf10+6hq3eNtCcNyPWcysZr2Ij9EvV2653qXeDn3Bc/
5tJ0/lxIWVy2PfkIIM8gN+pAJHV/8ZkFWiPz2CYjXGbrgy6WssqBhF2LIvCstE0=
=Rl+/
-----END PGP SIGNATURE-----

--qsoMWdMv/ifdm7CC--
