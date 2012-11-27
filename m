Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2K0QQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:16:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43905 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888Ab2K0QQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:16:01 -0500
Message-ID: <1354032951.4266.61.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 245/270] USB: mct_u232: fix broken close
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 16:15:51 +0000
In-Reply-To: <1353949160-26803-246-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-246-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3mFYSSTVKWeiiX8n+x7P"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3mFYSSTVKWeiiX8n+x7P
Content-Type: multipart/mixed; boundary="=-GHF+Tixev3szGS3UQrYt"


--=-GHF+Tixev3szGS3UQrYt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:58 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Johan Hovold <jhovold@gmail.com>
>=20
> commit 5260e458f5eff269a43e4f1e9c47186c57b88ddb upstream.
>=20
> Make sure generic close is called at close.
>=20
> The driver relies on the generic write implementation but did not call
> generic close.
>=20
> Note that the call to kill the read urb is not redundant, as mct_u232
> uses an interrupt urb from the second port as the read urb and that
> generic close therefore fails to kill it.
>=20
> Compile-only tested.
>=20
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
[...]

This is missing on 3.4; the version I used for 3.2 (attached) should be
applicable.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-GHF+Tixev3szGS3UQrYt
Content-Disposition: attachment; filename="usb-mct_u232-fix-broken-close.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="usb-mct_u232-fix-broken-close.patch"; charset="UTF-8"

RnJvbTogSm9oYW4gSG92b2xkIDxqaG92b2xkQGdtYWlsLmNvbT4NCkRhdGU6IFRodSwgMjUgT2N0
IDIwMTIgMTA6Mjk6MTQgKzAyMDANClN1YmplY3Q6IFVTQjogbWN0X3UyMzI6IGZpeCBicm9rZW4g
Y2xvc2UNCg0KY29tbWl0IDUyNjBlNDU4ZjVlZmYyNjlhNDNlNGYxZTljNDcxODZjNTdiODhkZGIg
dXBzdHJlYW0uDQoNCk1ha2Ugc3VyZSBnZW5lcmljIGNsb3NlIGlzIGNhbGxlZCBhdCBjbG9zZS4N
Cg0KVGhlIGRyaXZlciByZWxpZXMgb24gdGhlIGdlbmVyaWMgd3JpdGUgaW1wbGVtZW50YXRpb24g
YnV0IGRpZCBub3QgY2FsbA0KZ2VuZXJpYyBjbG9zZS4NCg0KTm90ZSB0aGF0IHRoZSBjYWxsIHRv
IGtpbGwgdGhlIHJlYWQgdXJiIGlzIG5vdCByZWR1bmRhbnQsIGFzIG1jdF91MjMyDQp1c2VzIGFu
IGludGVycnVwdCB1cmIgZnJvbSB0aGUgc2Vjb25kIHBvcnQgYXMgdGhlIHJlYWQgdXJiIGFuZCB0
aGF0DQpnZW5lcmljIGNsb3NlIHRoZXJlZm9yZSBmYWlscyB0byBraWxsIGl0Lg0KDQpDb21waWxl
LW9ubHkgdGVzdGVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBKb2hhbiBIb3ZvbGQgPGpob3ZvbGRAZ21h
aWwuY29tPg0KU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhm
b3VuZGF0aW9uLm9yZz4NCltid2g6IEJhY2twb3J0ZWQgdG8gMy4yOiBhZGp1c3QgY29udGV4dF0N
ClNpZ25lZC1vZmYtYnk6IEJlbiBIdXRjaGluZ3MgPGJlbkBkZWNhZGVudC5vcmcudWs+DQotLS0N
CiBkcml2ZXJzL3VzYi9zZXJpYWwvbWN0X3UyMzIuYyB8ICAgMTQgKysrKysrKystLS0tLS0NCiAx
IGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQotLS0gYS9k
cml2ZXJzL3VzYi9zZXJpYWwvbWN0X3UyMzIuYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL21j
dF91MjMyLmMNCkBAIC01NzcsMTIgKzU3NywxNCBAQCBzdGF0aWMgdm9pZCBtY3RfdTIzMl9jbG9z
ZShzdHJ1Y3QgdXNiX3NlDQogew0KIAlkYmcoIiVzIHBvcnQgJWQiLCBfX2Z1bmNfXywgcG9ydC0+
bnVtYmVyKTsNCiANCi0JaWYgKHBvcnQtPnNlcmlhbC0+ZGV2KSB7DQotCQkvKiBzaHV0ZG93biBv
dXIgdXJicyAqLw0KLQkJdXNiX2tpbGxfdXJiKHBvcnQtPndyaXRlX3VyYik7DQotCQl1c2Jfa2ls
bF91cmIocG9ydC0+cmVhZF91cmIpOw0KLQkJdXNiX2tpbGxfdXJiKHBvcnQtPmludGVycnVwdF9p
bl91cmIpOw0KLQl9DQorCS8qDQorCSAqIE11c3Qga2lsbCB0aGUgcmVhZCB1cmIgYXMgaXQgaXMg
YWN0dWFsbHkgYW4gaW50ZXJydXB0IHVyYiwgd2hpY2gNCisJICogZ2VuZXJpYyBjbG9zZSB0aHVz
IGZhaWxzIHRvIGtpbGwuDQorCSAqLw0KKwl1c2Jfa2lsbF91cmIocG9ydC0+cmVhZF91cmIpOw0K
Kwl1c2Jfa2lsbF91cmIocG9ydC0+aW50ZXJydXB0X2luX3VyYik7DQorDQorCXVzYl9zZXJpYWxf
Z2VuZXJpY19jbG9zZShwb3J0KTsNCiB9IC8qIG1jdF91MjMyX2Nsb3NlICovDQogDQogDQo=


--=-GHF+Tixev3szGS3UQrYt--

--=-3mFYSSTVKWeiiX8n+x7P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULTnN+e/yOyVhhEJAQrB4w/9ErMuxJaZHXrW737+uCg+egolh/4kM+Om
gEQeUeyyQdi8Ekemph0EnpH0RSoEA6ILmm8PZRr1DEIE3ykU1mZ8+Iu1f9akxwCO
34uG7CmDeGIBgZGoIXzQeaVLZkfZGLB86yfJXwR798iteHsun4VX/quoh9A0gDYz
916VxbWTr+vCV4MGJE/0eoBcO7CxzrajrhK2zxioSrbjW12Wo4c9pcIwBjyqs2+d
BsPSdCHpVnjTsZh7ipcVLUfhACsyXmPW3YJnSZ5Tt6rjZPDKIls5qP0GiDdF0c4q
Cd1AnpHhKPLop7hFiO456nhMKJvfHgfXpAs1+6y5DkCwIpTEqn/lp2BykCZa715s
fhgooLeWuED6lHMj9szzHiO1LihmmvMhXdKq9VBHIOjECc7XdkpRNM45Z/enRZAq
BQuCrGsvOvDclIHxjhm3dbyh2/cZIJY6RsFBTbArOgw8v4WjS86/XElrra5cTE4M
LNFgVk8K9X8SubsZ6jLhq54YRiDY0ANnjIWi14EjIFi8+BEft7g7bSwdZrDndWK9
M1fhnesS7iwgZEfSSbq4ISPN0VTzP8p9AxJMCVdrlF+XdXL5bzylM0IbQaeRH9Q3
DdQ71c4fGzASugCEjJ//0AXpITwFu1YmQM0UH8rrENQwlg9vcJeLf1eiiY+djL1H
k9wOiGjeS48=
=/U34
-----END PGP SIGNATURE-----

--=-3mFYSSTVKWeiiX8n+x7P--
