Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab1JGMzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:55:21 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:57468 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752531Ab1JGMzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:55:20 -0400
Date: Fri, 7 Oct 2011 15:55:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: balbi@ti.com, Klaus Schwarzkopf <schwarzkopf@sensortherm.de>,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20111007125511.GC18364@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20111006120830.GN1714@legolas.emea.dhcp.ti.com>
 <4E8EB6EE.8040700@sensortherm.de>
 <20111007083856.GB10910@legolas.emea.dhcp.ti.com>
 <4E8ECF44.7060506@sensortherm.de>
 <20111007101414.GN10910@legolas.emea.dhcp.ti.com>
 <4E8EDEEE.2090907@ru.mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <4E8EDEEE.2090907@ru.mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 07, 2011 at 03:13:50PM +0400, Sergei Shtylyov wrote:
> >>include/linux/device.h:705: error: conflicting types for =E2=80=98dev_g=
et_drvdata=E2=80=99
> >>include/linux/usb/gadget.h:497: note: previous implicit declaration
> >>of =E2=80=98dev_get_drvdata=E2=80=99 was here
> >>In file included from drivers/usb/gadget/acm_ms.c:44:
> >>drivers/usb/gadget/composite.c:1261: error: field name not in record
> >>or union initializer
> >>drivers/usb/gadget/composite.c:1261: error: (near initialization for
> >>=E2=80=98composite_driver.driver=E2=80=99)
> >>make[3]: *** [drivers/usb/gadget/acm_ms.o] Error 1
> >>make[2]: *** [drivers/usb/gadget] Error 2
> >>make[1]: *** [drivers/usb] Error 2
> >>make: *** [drivers] Error 2
>=20
> >I believe Sergei had that patch already, but it wasn't applied for some
> >reason. Sergei, do you happen to remember the outcome of that patch ?
>=20
>    It has been apllied allright to 3.1-rc1. :-)

very true. and I need memory pills as it went through me :-)

--=20
balbi

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjvavAAoJEAv8Txj19kN1z04H/20xjvWBXMUuDaaEdSClZUZe
DZjWLJwcCIzhFpLUNV1CLuhOQTlZClmqCkpIGdNNCHvNCpGP/CXH6Vw0bQRI9dVK
jGUkHA2xwyX+1h/8YGRfp/vPHmjX8LtzS6FIGkBsGj8qlUOhNetXWHa3QAsAzn+Q
g04lJ5dO2sToVSZBC3vN75p73H+Jm4gHoid/ja8dmZdHR/J5Y827UdakFRph9TRd
Ubs/EiZC8zsQST8SamkOF+jUQZzWIRiBcOPii53zYJEiUFmKY9q/QwDxksqtifCQ
ZEyIVUr6AnzNe4FOpVzE9NAx0lkIClXwL7BX6Mqp1J+nbSrWbSMEk46gMFQBtzQ=
=LBNn
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
