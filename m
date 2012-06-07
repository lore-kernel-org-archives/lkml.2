Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2FGAlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:41:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:8750 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858Ab2FGAlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:41:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="153951916"
Message-ID: <1339029671.10602.81.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [next-net PATCH]
 drivers/net/ethernet/intel/e1000e: fix unregistered net_device ethX name
 output by e1000e
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: eric.dumazet@gmail.com, linux.nics@intel.com,
        e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 06 Jun 2012 17:41:11 -0700
In-Reply-To: <CABawtvNv7LwT_awXscXGEid-1wes-+ZELc7YMLZqyo2h=h98UA@mail.gmail.com>
References: <CABawtvNv7LwT_awXscXGEid-1wes-+ZELc7YMLZqyo2h=h98UA@mail.gmail.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YXBi4oF6dToZVndGR90t"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YXBi4oF6dToZVndGR90t
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-06 at 22:57 +0800, Ethan Zhao wrote:
> commit ca3ccc6835943287b6f69e973c126a02bc4de409
> Author: ethan.zhao <ethan.kernel@gmail.com>
> Date:   Wed Jun 6 07:32:11 2012 -0700
>=20
>         modified:   drivers/net/ethernet/intel/e1000e/param.c
>=20
>     While e1000e_check_options() is called, netdev is not registered,
> so the
>     e1000e driver will print out confused ethernet interface name
> (unregistered net_device) :
>=20
>     e1000e 0000:04:00.0:(unregistered net_device): Interrupt
> Throttling Rate (ints/sec) set to dynamic conservative mode
>=20
>     So change e_info() back to dev_printk() by simply redefine the
> e_info macro used by
>     e1000e_check_options() and e1000_validate_option
>=20
>     after applied this patch, we got:
>=20
>     e1000e 0000:04:00.0: Interrupt Throttling Rate (ints/sec) set to
> dynamic conservative mode
>     e1000e 0000:04:00.0: irq 95 for MSI/MSI-X=20

NACK, I currently have a patch in my queue from Bruce Allan to resolve
this issue.  I should be pushing the patch upstream in a few days.

--=-YXBi4oF6dToZVndGR90t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJPz/inAAoJEOVv75VaS+3OldUP/3+hmOqKahHcY8b1TuuoDUCp
kN73G1R7F4zFm+Y1+3zV2uwxMlRW/7W+eOEWF+icTrUnrjypIpX1XAhsWfpibbwV
E3r5vPI/ZJyPK9RD8IW4yRabfdmOq+FuMI7TynnEJECb9FuPuzBia44i52rXDgig
qrthBXaspAVVVj47CzIDPqP18omB7q3F12mk5fCAG8lVcLpA8JGpE0vfsUk+HC9U
Aj+96olKx3o323l84OdJdcZWJlRlnbsmTYwXqtRqga3hwjcP+uPBtilmO5TcbbCj
SQ2Lb8v5xfMK9WtQIVI0ZKqK8N0PS2qXue6UUHeQQ2nKjaFQLC8KhOd42VDvsh97
e8D2IGMh5zWGZq4HiFncE+P1DijrQQht05wYXxebAaSn+9IHjgtaHKLVdL1CR2vA
s4+m9hvdZENzeiivshJhteZnmZunyw+5It5xBwYFxESt2Tnl+5z737TmqrpyLS2f
ptbcpgtVbIlt8r9NSaL3Jn8JLl3wRSR/1E4qefYg7f8N+fri3V9Q3ugfhZDhDl/O
3gptslNycE2m1mocb57C8SqpBWvg/JEfBZiKCvStATFR+IJNKLHLnMTzxVdQYHpj
SX36AyTdjRgrRQeZI1e/c5PMhdE5XxYG85drB3sTkrq+p2Vve3/9Qafnxpbw2o6Y
KwMOk6PRixd+c3tcl6JL
=D+Jc
-----END PGP SIGNATURE-----

--=-YXBi4oF6dToZVndGR90t--

