Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1GZPAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:00:05 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47440 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab1GZO77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:59:59 -0400
Date: Tue, 26 Jul 2011 17:59:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Patch] fusb300_udc: remove unused function
 fusb300_ep0_complete()
Message-ID: <20110726145953.GI32582@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <CAM_iQpX84cR+9s3nL-p5V3a=bQgmRwJ5jhWpLY0WNS3TO8f8LQ@mail.gmail.com>
 <20110726145315.GE32582@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cjXvCArabh/jFWdZ"
Content-Disposition: inline
In-Reply-To: <20110726145315.GE32582@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cjXvCArabh/jFWdZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 26, 2011 at 05:53:16PM +0300, Felipe Balbi wrote:
> On Sun, Jul 17, 2011 at 05:53:39PM +0800, Am=E9rico Wang wrote:
> > It is not used, so just remove it.
> >=20
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
>=20
> applied, thanks.
>=20
> (next time, please put patch inline on the mail rather than as
> attachment ;-)

actually, sorry. This doesn't apply, care to re-spin if necessary.

--=20
balbi

--cjXvCArabh/jFWdZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLtZpAAoJEAv8Txj19kN1dXsH/01U9ThzwSRV94zsx6BTrkVz
HgP6BVQOEgkm7IDW/BeTkXeS3S14V6cPEG83TIrn/W6XTq+vfHNNd3ESeIMsk2LI
CjZ1y/m/n0NyEWMHjFRlnKi3RsUAYaWlKNL7N9Ra8IE/LgAdo1/Ojkd38Y7kCbyY
Nr3cPHgm0XjxqSo2SC0kEt1n5QIB5965QGBcNpw+WUkhWHNiN500evap0Sv0TbBB
YffmnT7pwZd7q6wDjjNwoSG9m5mXEfEp/COKWyum4PE3/DEkpCRRjVisupRgWWo1
OSxGYrSuMqtpa4NZ7JD73/RrH4j229tjxxkXWYTbuBtWUqDMpMko5RBwbAMMf9U=
=qlXL
-----END PGP SIGNATURE-----

--cjXvCArabh/jFWdZ--
