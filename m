Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1EFX6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 19:58:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34879 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab1EFX6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 19:58:30 -0400
Message-ID: <4DC48B18.1010309@pengutronix.de>
Date: Sat, 07 May 2011 01:58:16 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
CC: "'Wolfgang Grandegger'" <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, toshiharu-linux@dsn.okisemi.com
Subject: Re: Question for canutils
References: <02D6556ECE7A41859777EB7300D12394@hacdom.okisemi.com> <4DB81F2E.4050802@pengutronix.de> <A42D429EA0C74B64BB1BFE96BBFA9815@hacdom.okisemi.com>
In-Reply-To: <A42D429EA0C74B64BB1BFE96BBFA9815@hacdom.okisemi.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7E3F777774FD6ABC57D37D9E"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7E3F777774FD6ABC57D37D9E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/06/2011 02:37 AM, Tomoya MORINAGA wrote:
> Hi Marc,
>=20
> On Wednesday, April 27, 2011 10:51 PM, Marc Kleine-Budde wrote:
>> Into which location?
>>
>> Please send me the output of:
>>
>> ls -l /usr/local/lib
>> ls -l /usr/local/lib/pkgconfig
>=20
> [morinaga@localhost ~]$=20
> [morinaga@localhost ~]$ ls -l /usr/local/lib
> =E5=90=88=E8=A8=88 1412
> -rw-r--r--. 1 root root 103226 2011-01-13 16:56 libhistory.a
> lrwxrwxrwx. 1 root root     15 2011-01-13 16:56 libhistory.so -> libhis=
tory.so.6
> lrwxrwxrwx. 1 root root     17 2011-01-13 16:56 libhistory.so.6 -> libh=
istory.so.6.0
> -r-xr-xr-x. 1 root root  80204 2011-01-13 16:56 libhistory.so.6.0
> -rw-r--r--. 1 root root 686760 2011-01-13 16:56 libreadline.a
> lrwxrwxrwx. 1 root root     16 2011-01-13 16:56 libreadline.so -> libre=
adline.so.6
> lrwxrwxrwx. 1 root root     18 2011-01-13 16:56 libreadline.so.6 -> lib=
readline.so.6.0
> -r-xr-xr-x. 1 root root 498839 2011-01-13 16:56 libreadline.so.6.0
> -rw-r--r--. 1 root root  28718 2011-04-27 15:40 libsocketcan.a
> -rwxr-xr-x. 1 root root    843 2011-04-27 15:40 libsocketcan.la
> lrwxrwxrwx. 1 root root     21 2011-04-27 15:40 libsocketcan.so -> libs=
ocketcan.so.2.2.0
> lrwxrwxrwx. 1 root root     21 2011-04-27 15:40 libsocketcan.so.2 -> li=
bsocketcan.so.2.2.0
> -rwxr-xr-x. 1 root root  27835 2011-04-27 15:40 libsocketcan.so.2.2.0
> drwxr-xr-x. 2 root root   4096 2011-04-27 15:53 pkgconfig
> [morinaga@localhost ~]$ ls -l /usr/local/lib/pkgconfig/
> =E5=90=88=E8=A8=88 8
> -rw-r--r--. 1 root root 198 2011-04-27 15:53 canutils.pc
> -rw-r--r--. 1 root root 300 2011-04-27 15:40 libsocketcan.pc
> [morinaga@localhost ~]$=20
>=20
>=20
>> First build the canutils, then configure the bitrate, e.g. 250 kbit/s:=

>>     $ canconfig can0 bitrate 250000
>>     $ ifconfig can0 up
> The above commands failed.
>=20
> [root@localhost can]#=20
> [root@localhost can]# canconfig can0 bitrate 250000
> opening CAN interface 'can0' in sysfs failed, maybe not a CAN interface=

> No such file or directory

you have to use canutils 4.x, not 3.x. (or ip from iprout2) to setup the
bitrate.

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig7E3F777774FD6ABC57D37D9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3EixwACgkQjTAFq1RaXHNdwACfWfAats9EttEU2gqyQmqfTAVV
RugAnjrnO+LrXO+6Fh4myXkw8cNq4eko
=JCXS
-----END PGP SIGNATURE-----

--------------enig7E3F777774FD6ABC57D37D9E--
