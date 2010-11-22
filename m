Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab0KVAn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:43:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44307 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab0KVAn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:43:28 -0500
Date: Mon, 22 Nov 2010 11:43:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Martin Wilks <m.wilks@technisat.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20101122114315.687b4bd5.sfr@canb.auug.org.au>
In-Reply-To: <20101115102554.67514e8d.sfr@canb.auug.org.au>
References: <20101115102554.67514e8d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Nov_2010_11_43_15_+1100_v/0FTYrJTyxH92lT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Nov_2010_11_43_15_+1100_v/0FTYrJTyxH92lT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Mon, 15 Nov 2010 10:25:54 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/media/dvb/dvb-usb/technisat-usb2.c: In function 'technisat_usb2_g=
et_ir':
> drivers/media/dvb/dvb-usb/technisat-usb2.c:643: error: 'struct dvb_usb_de=
vice' has no member named 'rc_input_dev'
> drivers/media/dvb/dvb-usb/technisat-usb2.c:649: error: 'struct dvb_usb_de=
vice' has no member named 'rc_input_dev'
> drivers/media/dvb/dvb-usb/technisat-usb2.c:654: error: 'struct dvb_usb_de=
vice' has no member named 'rc_input_dev'
> drivers/media/dvb/dvb-usb/technisat-usb2.c: At top level:
> drivers/media/dvb/dvb-usb/technisat-usb2.c:732: error: unknown field 'rc_=
props' specified in initializer
> drivers/media/dvb/dvb-usb/technisat-usb2.c:732: warning: braces around sc=
alar initializer
> drivers/media/dvb/dvb-usb/technisat-usb2.c:732: warning: (near initializa=
tion for 'technisat_usb2_devices.rc.core.rc_interval')
> drivers/media/dvb/dvb-usb/technisat-usb2.c:733: error: field name not in =
record or union initializer
> drivers/media/dvb/dvb-usb/technisat-usb2.c:733: error: (near initializati=
on for 'technisat_usb2_devices.rc.core.rc_interval')
> drivers/media/dvb/dvb-usb/technisat-usb2.c:734: error: field name not in =
record or union initializer
> drivers/media/dvb/dvb-usb/technisat-usb2.c:734: error: (near initializati=
on for 'technisat_usb2_devices.rc.core.rc_interval')
> drivers/media/dvb/dvb-usb/technisat-usb2.c:734: warning: excess elements =
in scalar initializer
> drivers/media/dvb/dvb-usb/technisat-usb2.c:734: warning: (near initializa=
tion for 'technisat_usb2_devices.rc.core.rc_interval')
> make[5]: *** No rule to make target `drivers/media/rc/keymaps/rc-technisa=
t-usb2.c', needed by `drivers/media/rc/keymaps/rc-technisat-usb2.o'.  Stop.
>=20
> Caused by commit f29235d71ad3995ef9f74ad2f5931eca4ecabdcd ("[media]
> technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver")
> interacting with commit 1639cc0c5348957c076c0304005632d4a1b63252
> ("[media] ir-core: make struct rc_dev the primary interface").
>=20
> Please make sure your build tests build new/modified files.
>=20
> I have used the v4l-dvb tree from next-20101112 for today.

This is still failing ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Nov_2010_11_43_15_+1100_v/0FTYrJTyxH92lT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM6byjAAoJEDMEi1NhKgbsIsAH/j8KrY31QDHKSU7A/ssUSjLv
OSKHj4IYimFbnah0tDKrm4oFMlKmSta4zNg0z8Yvg9z7YomDC5eh66XzaWV5Y2gC
3GrnQi6UCcUSrPs5S+/V98yCeTCDfXMfoLflqtb5Pi77FJ8o0MV8B48WvVXi5wRK
o2In51t3h30QvifhO0l/UEL4XnSAprxd0o93GSH17mZd9+XZySHvaU/FYbbR+XVn
5H9UuTMpsOQ21p2epkKXTKRxAafOjqRz7rx0P4pcA+gaAE2DhiJLXmZhFNAI/Egl
qQb65hgJQOCaf5xNWIQATWJyKf1ArQyOvtWMz1kWW7lPYNUyXf14D9hN/TD0yw8=
=dMOC
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Nov_2010_11_43_15_+1100_v/0FTYrJTyxH92lT--
