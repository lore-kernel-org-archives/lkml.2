Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab1JGKO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:14:26 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:38894 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965019Ab1JGKOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:14:23 -0400
Date: Fri, 7 Oct 2011 13:14:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20111007101414.GN10910@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20111006120830.GN1714@legolas.emea.dhcp.ti.com>
 <4E8EB6EE.8040700@sensortherm.de>
 <20111007083856.GB10910@legolas.emea.dhcp.ti.com>
 <4E8ECF44.7060506@sensortherm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jnYfR+Q8IWTs8BNa"
Content-Disposition: inline
In-Reply-To: <4E8ECF44.7060506@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jnYfR+Q8IWTs8BNa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 07, 2011 at 12:07:00PM +0200, Klaus Schwarzkopf wrote:
> Hi,
>=20
>=20
> Am 07.10.2011 10:38, schrieb Felipe Balbi:
>=20
> >>>>diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> >>>>index dd1571d..f623f3d 100644
> >>>>--- a/include/linux/usb/gadget.h
> >>>>+++ b/include/linux/usb/gadget.h
> >>>>@@ -15,6 +15,7 @@
> >>>>  #ifndef __LINUX_USB_GADGET_H
> >>>>  #define __LINUX_USB_GADGET_H
> >>>>
> >>>>+#include<linux/device.h>
> >>>
> >>>this is not part of $SUBJECT
> >>>
> >>
> >>changed git message
> >
> >not enough. adding another header is not part of this patch. You need to
> >let us know why you need this new header there and you need add proper
> >spacing there.
> >
>=20
>=20
> There is a space in the orginal patch.
>=20
> Should i make a seperate patch for this?
>=20
> In the header gadget.h are some stuff used, but not declared.
>=20
> My compile errors without device.h:
>=20
>   CC      drivers/usb/gadget/acm_ms.o
> In file included from include/linux/usb/composite.h:38,
>                  from drivers/usb/gadget/u_serial.h:15,
>                  from drivers/usb/gadget/acm_ms.c:20:
> include/linux/usb/gadget.h:491: error: field =E2=80=98dev=E2=80=99 has in=
complete type
> include/linux/usb/gadget.h: In function =E2=80=98set_gadget_data=E2=80=99:
> include/linux/usb/gadget.h:495: error: implicit declaration of
> function =E2=80=98dev_set_drvdata=E2=80=99
> include/linux/usb/gadget.h: In function =E2=80=98get_gadget_data=E2=80=99:
> include/linux/usb/gadget.h:497: error: implicit declaration of
> function =E2=80=98dev_get_drvdata=E2=80=99
> include/linux/usb/gadget.h: In function =E2=80=98dev_to_usb_gadget=E2=80=
=99:
> include/linux/usb/gadget.h:500: warning: type defaults to =E2=80=98int=E2=
=80=99 in
> declaration of =E2=80=98__mptr=E2=80=99
> include/linux/usb/gadget.h:500: warning: initialization from
> incompatible pointer type
> include/linux/usb/gadget.h: At top level:
> include/linux/usb/gadget.h:781: error: field =E2=80=98driver=E2=80=99 has=
 incomplete type
> In file included from drivers/usb/gadget/composite.c:26,
>                  from drivers/usb/gadget/acm_ms.c:44:
> include/linux/device.h:705: error: conflicting types for =E2=80=98dev_get=
_drvdata=E2=80=99
> include/linux/usb/gadget.h:497: note: previous implicit declaration
> of =E2=80=98dev_get_drvdata=E2=80=99 was here
> In file included from drivers/usb/gadget/acm_ms.c:44:
> drivers/usb/gadget/composite.c:1261: error: field name not in record
> or union initializer
> drivers/usb/gadget/composite.c:1261: error: (near initialization for
> =E2=80=98composite_driver.driver=E2=80=99)
> make[3]: *** [drivers/usb/gadget/acm_ms.o] Error 1
> make[2]: *** [drivers/usb/gadget] Error 2
> make[1]: *** [drivers/usb] Error 2
> make: *** [drivers] Error 2

I believe Sergei had that patch already, but it wasn't applied for some
reason. Sergei, do you happen to remember the outcome of that patch ?

--=20
balbi

--jnYfR+Q8IWTs8BNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjtD1AAoJEAv8Txj19kN1CWAH/i0VBldwR0QeE/CzpsCdaBZM
tSNDMHbdYmmtqvcFR4valF3rIgzXC5QCD0SAEWsSJGP4uafZLAOlpAcXI+k1gqj3
qFPvLK0vAWxvv/nvgcRmARSHl9ZeYECBqf89qRbTKLid60NDV2hmZ+/znIqMTimQ
3KJ/oNuoMivOUmxkGSu195HT65srm4c0CiHFDcIEUUUBGh1LF8e0h5lnjCyLlFaT
omR+XPoNsNX72Gs71v7de2wRusfp9yISEaPwSDzqGP/hqJFeDF61+wrjDW3KAbMd
BelL1gXor4kSCagMhPM31GgK4GI4QCjgWThXiOkRppNi6A0s+HdpT8IqE2d9GF4=
=VXF+
-----END PGP SIGNATURE-----

--jnYfR+Q8IWTs8BNa--
