Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1FCJfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:35:11 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:55174 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1FCJfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:35:09 -0400
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h8JiYXs/HrEl2yUn8V3w==
X-RZG-CLASS-ID: mo05
Message-ID: <4DE8AAC6.6020507@samba.org>
Date: Fri, 03 Jun 2011 11:35:02 +0200
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexey ORISHKO <alexey.orishko@stericsson.com>
CC: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
References: <1306922913-17803-1-git-send-email-metze@samba.org> <1306922913-17803-2-git-send-email-metze@samba.org> <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E583@EXDCVYMBSTM006.EQ1STM.local> <4DE618B7.5070903@samba.org> <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E64B@EXDCVYMBSTM006.EQ1STM.local> <4DE6287D.5080807@samba.org> <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E6F2@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E6F2@EXDCVYMBSTM006.EQ1STM.local>
X-Enigmail-Version: 1.1.2
OpenPGP: id=0E53083F
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig60248AFEEDF0374A253200F2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig60248AFEEDF0374A253200F2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.06.2011 14:27, schrieb Alexey ORISHKO:
>> -----Original Message-----
>> From: Stefan (metze) Metzmacher [mailto:metze@samba.org]
>> Sent: Wednesday, June 01, 2011 1:55 PM
>=20
>>> If you use udev rules and create an alias for your device, you won't
>>> be dependent on generic driver code.
>>
>> Ok, do you have examples for that?
>=20
> Please, read udev man pages. Rule might be as follows
> KERNEL=3D=3D"usb*", ATTRS{idVendor}=3D=3D"04cc", ATTRS{idProduct}=3D=3D=
"xxxx", NAME=3D"ste_bridge0"

Thanks! I got something that works.

metze


--------------enig60248AFEEDF0374A253200F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3oqsYACgkQm70gjA5TCD87CwCgzXWJmSZVm4/tJ6xiDfYrRJ3z
osoAn1x39yrneUMWepRISZLggnv8jQ2i
=WwP2
-----END PGP SIGNATURE-----

--------------enig60248AFEEDF0374A253200F2--
