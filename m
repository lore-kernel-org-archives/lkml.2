Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab2D0IIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:08:20 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:50175 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757718Ab2D0IID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:08:03 -0400
Date: Fri, 27 Apr 2012 11:00:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Partha Basak <p-basak2@ti.com>
Subject: Re: [ 43/62] usb: gadget: udc-core: fix asymmetric calls in
 remove_driver
Message-ID: <20120427080046.GD3411@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120424223305.GA7748@kroah.com>
 <20120424223245.670329887@linuxfoundation.org>
 <20120426003435.GI3932@decadent.org.uk>
 <20120426211632.GC372@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <20120426211632.GC372@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 26, 2012 at 02:16:32PM -0700, Greg KH wrote:
> On Thu, Apr 26, 2012 at 01:34:35AM +0100, Ben Hutchings wrote:
> > On Tue, Apr 24, 2012 at 03:33:24PM -0700, Greg KH wrote:
> > > 3.3-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Kishon Vijay Abraham I <kishon@ti.com>
> > >=20
> > > commit 8ae8090c82eb407267001f75b3d256b3bd4ae691 upstream.
> > >=20
> > > During modprobe of gadget driver, pullup is called after
> > > udc_start. In order to make the exit path symmetric when
> > > removing a gadget driver, call pullup before ->udc_stop.
> > [...]
> > =20
> > It looks like commit 6d258a4c42089229b855fd706622029decf316d6
> > (previous patch in this series!) added another case where the
> > cleanup functions are called in the wrong order.
>=20
> Felipe?  Any thoughts?

oops, indeed. Will send a fix ASAP. Thanks for spotting that one.

--=20
balbi

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmlIuAAoJEIaOsuA1yqREmsAQAJOahS01Y2AfK6aCDWvpbtqH
cYheyRNCPEH5io0KqsZa5ipXxiSIsNA3CiJZ8z+kv8Zl8/it3eH0dqcnc2K13uEy
nntr/Ki5I8X0skmXeOGA7T+CrzTdHphz4ZLOZLu2jEG+NWN7/hd+ixyOsuicqrqh
S8cz/myZ2CmqXQ28kDA4B0y08J5dEx9aePKlhT8bA7APC1CK8Xqzr/CUPvgkbXeQ
f+z/suU6LBYvQuAVv56mJTaTlrFBWMpkwm0hpgfCj5zZbtpICT1cuFWbcrYywbF2
UGDW94ltFYvm9hdYu9h770uB96ort+T84Fu3dikhtPIfXTAqYWhtqk0y7Oj7fEBR
8HRqyz3dfDIUxIKzu2DJFgnGlbCjBz8ibn6HA//6M9PXIZfsqmsgdwEc1Dbg2HY6
LNKAzcK2kITDqvFwKA6LnmwLtOBhSxkGiSASt8YpnBimpOMXxWsVT/SdBZ02Gq4k
jQVXzxTi9UezXgiiSlw7vxbb7Xj4OmogkRh/X9IACJp+ouCwRhVCJuu8cXnnNntH
5MnebclM4os9y3kbyDwymmZ8iDhGneuegvaG0Hc9FrdosYzBAFKmle5DTJ8hzKhA
7eTE97+LNUumT7re0Km9GYiVz8zjkBmR49lDy+5JcCUlZzDLZVzh62DsrMFEg+zJ
KouXR2HbtPyV9L5s1DOu
=ayLb
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--
