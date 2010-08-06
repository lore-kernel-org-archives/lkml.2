Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537Ab0HFPfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:35:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:47231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab0HFPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:35:45 -0400
Subject: [PATCH] usb: add device IDs for igotu to navman
From: Ross Burton <ross@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-63p1DNYvqfljc9sk9i/T"
Organization: Intel
Date: Fri, 06 Aug 2010 16:36:39 +0100
Message-ID: <1281108999.3781.50.camel@flashheart.burtonini.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-63p1DNYvqfljc9sk9i/T
Content-Type: multipart/mixed; boundary="=-dZ/PU2opf1K8HpLFLQZb"


--=-dZ/PU2opf1K8HpLFLQZb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

I recently bought a i-gotU USB GPS, and whilst hunting around for linux
support discovered this post by you back in 2009:

http://kerneltrap.org/mailarchive/linux-usb/2009/3/12/5148644

>Try the navman driver instead.  You can either add the device id to the
> driver and rebuild it, or do this before you plug the device in:
> 	modprobe navman
> 	echo -n "0x0df7 0x0900" > /sys/bus/usb-serial/drivers/navman/new_id
>=20
> and then plug your device in and see if that works.
=20
I can confirm that the navman driver works with the right device IDs on
my i-gotU GT-600, which has the same device IDs.  Attached is a patch
adding the IDs.

Ross
--=20
Intel Open Source Technology Centre
http://oss.intel.com/

--=-dZ/PU2opf1K8HpLFLQZb
Content-Disposition: attachment; filename="0001-usb-add-device-IDs-for-igotu-to-navman.patch"
Content-Type: text/x-patch; name="0001-usb-add-device-IDs-for-igotu-to-navman.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBiYWQ4NTJhOTc2ODNmMjJmNjY3N2YzMTJiNzNhZTdhZTk3NDQyMTJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogUm9zcyBCdXJ0b24gPHJvc3NAbGludXguaW50ZWwuY29tPg0K
RGF0ZTogRnJpLCA2IEF1ZyAyMDEwIDE2OjMxOjQ5ICswMTAwDQpTdWJqZWN0OiBbUEFUQ0hdIHVz
YjogYWRkIGRldmljZSBJRHMgZm9yIGlnb3R1IHRvIG5hdm1hbg0KDQotLS0NCiBkcml2ZXJzL3Vz
Yi9zZXJpYWwvbmF2bWFuLmMgfCAgICAxICsNCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
cygrKSwgMCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9u
YXZtYW4uYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9uYXZtYW4uYw0KaW5kZXggYTZiMjA3Yy4uYzA0
M2FhMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9uYXZtYW4uYw0KKysrIGIvZHJp
dmVycy91c2Ivc2VyaWFsL25hdm1hbi5jDQpAQCAtMjUsNiArMjUsNyBAQCBzdGF0aWMgaW50IGRl
YnVnOw0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBpZF90YWJsZVtdID0g
ew0KIAl7IFVTQl9ERVZJQ0UoMHgwYTk5LCAweDAwMDEpIH0sCS8qIFRhbG9uIFRlY2hub2xvZ3kg
ZGV2aWNlICovDQorICAgICAgICB7IFVTQl9ERVZJQ0UoMHgwZGY3LCAweDA5MDApIH0sIC8qIE1v
YmlsZSBBY3Rpb24gaS1nb3RVICovDQogCXsgfSwNCiB9Ow0KIE1PRFVMRV9ERVZJQ0VfVEFCTEUo
dXNiLCBpZF90YWJsZSk7DQotLSANCjEuNy4xDQoNCg==


--=-dZ/PU2opf1K8HpLFLQZb--

--=-63p1DNYvqfljc9sk9i/T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMXCwFLQnkR9C0M98RAjuPAJ9CYUcmkcb5OX2ThdAWdfcVNosyRQCfe577
IYDOcHtdk7lIuh5MpoyyD/U=
=P+cS
-----END PGP SIGNATURE-----

--=-63p1DNYvqfljc9sk9i/T--
