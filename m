Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2KPQOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:14:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50541 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665Ab2KPQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:14:17 -0500
Message-ID: <1353082447.4867.88.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 21/66] drm/i915: fix overlay on i830M
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Rhys <rhyspuk@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Fri, 16 Nov 2012 16:14:07 +0000
In-Reply-To: <20121115040940.540633203@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
	 <20121115040940.540633203@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8MifrlCffLB+NiLm0Qf6"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8MifrlCffLB+NiLm0Qf6
Content-Type: multipart/mixed; boundary="=-wm9jYJgplu2kdSmE36k3"


--=-wm9jYJgplu2kdSmE36k3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-14 at 20:10 -0800, Greg Kroah-Hartman wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
>=20
> commit a9193983f4f292a82a00c72971c17ec0ee8c6c15 upstream.
[...]

I notice you didn't apply this to 3.0 and 3.4.  I'm attaching the
version I used for 3.2.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-wm9jYJgplu2kdSmE36k3
Content-Disposition: attachment; filename="drm-i915-fix-overlay-on-i830m.patch"
Content-Type: text/x-patch; name="drm-i915-fix-overlay-on-i830m.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbTogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4NCkRhdGU6IE1vbiwg
MjIgT2N0IDIwMTIgMTI6NTU6NTUgKzAyMDANClN1YmplY3Q6IGRybS9pOTE1OiBmaXggb3Zlcmxh
eSBvbiBpODMwTQ0KTUlNRS1WZXJzaW9uOiAxLjANCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsg
Y2hhcnNldD1VVEYtOA0KQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdA0KDQpjb21taXQg
YTkxOTM5ODNmNGYyOTJhODJhMDBjNzI5NzFjMTdlYzBlZThjNmMxNSB1cHN0cmVhbS4NCg0KVGhl
IG92ZXJsYXkgb24gdGhlIGk4MzBNIGhhcyBhIHBlY3VsaWFyIGZhaWx1cmUgbW9kZTogSXQgd29y
a3MgdGhlDQpmaXJzdCB0aW1lIGFyb3VuZCBhZnRlciBib290LXVwLCBidXQgY29uc2lzdGVubHkg
aGFuZ3MgdGhlIHNlY29uZCB0aW1lDQppdCdzIHVzZWQuDQoNCkNocmlzIFdpbHNvbiBoYXMgZHVn
IG91dCBhIG5pY2UgZXJyYXRhOg0KDQoiMS41LjEyIENsb2NrIEdhdGluZyBEaXNhYmxlIGZvciBE
aXNwbGF5IFJlZ2lzdGVyDQpBZGRyZXNzIE9mZnNldDoJMDYyMDBo4oCTMDYyMDNoDQoNCiJCaXQg
Mw0KT3ZydW5pdCBDbG9jayBHYXRpbmcgRGlzYWJsZS4NCjAgPSBDbG9jayBnYXRpbmcgY29udHJv
bGxlZCBieSB1bml0IGVuYWJsaW5nIGxvZ2ljDQoxID0gRGlzYWJsZSBjbG9jayBnYXRpbmcgZnVu
Y3Rpb24NCkRldkFMTSBFcnJhdGEgQUxNMDQ5OiBPdmVybGF5IENsb2NrIEdhdGluZyBNdXN0IGJl
IERpc2FibGVkOiAgT3ZlcmxheQ0KJiBMMiBDYWNoZSBjbG9jayBnYXRpbmcgbXVzdCBiZSBkaXNh
YmxlZCBpbiBvcmRlciB0byBwcmV2ZW50IGRldmljZQ0KaGFuZ3Mgd2hlbiB0dXJuaW5nIG9mZiBv
dmVybGF5LlNXIG11c3QgdHVybiBvZmYgT3ZydW5pdCBjbG9jayBnYXRpbmcNCig2MjAwaCkgYW5k
IEwyIENhY2hlIGNsb2NrIGdhdGluZyAoQzhoKS4iDQoNCk5vdyBJJ3ZlIG5vd2hlcmUgZm91bmQg
dGhhdCAweGM4IHJlZ2lzdGVyIGFuZCBoZW5jZSBjb3VsZG4ndCBhcHBseSB0aGUNCmwyIGNhY2hl
IHdvcmthcm91bmQuIEJ1dCBJJ3ZlIHJlbWVtYmVyZWQgdGhhdCBwYXJ0IG9mIHRoZSBtYWdpYyB0
aGF0DQp0aGUgT1ZFUkxBWV9PTi9PRkYgY29tbWFuZHMgYXJlIHN1cHBvc2VkIHRvIGRvIGlzIHRv
IHJlYXJyYW5nZSBjYWNoZQ0KYWxsb2NhdGlvbnMgc28gdGhhdCB0aGUgb3ZlcmxheSBzY2FsZXIg
aGFzIHNvbWUgc2NyYXRjaCBzcGFjZS4NCg0KQW5kIHdoaWxlIHBvbmRlcmluZyBob3cgdGhhdCBj
b3VsZCBleHBsYWluIHRoZSBoYW5nIHRoZSAybmQgdGltZSB3ZQ0KZW5hYmxlIHRoZSBvdmVybGF5
LCBJJ3ZlIHJlbWVtYmVyZWQgdGhhdCB0aGUgb2xkIHVtcyBvdmVybGF5IGNvZGUgZGlkDQpfbm90
XyBpc3N1ZSB0aGUgT1ZFUkxBWV9PRkYgY21kLg0KDQpBbmQgaW5kZWVkLCBkaXNhYmxpbmcgdGhl
IE9GRiBjbWQgcmVzdWx0cyBpbiB0aGUgb3ZlcmxheSB3b3JraW5nDQpmbGF3bGVzc2x5LCBzbyBJ
IGd1ZXNzIHdlIGNhbiB3b3JrYXJvdW5kIHRoZSBsYWNrIG9mIHRoZSBhYm92ZQ0Kd29ya2Fyb3Vu
ZCBieSBzaW1wbHkgbmV2ZXIgZGlzYWJsaW5nIHRoZSBvdmVybGF5IGVuZ2luZSBvbmNlIGl0J3MN
CmVuYWJsZWQuDQoNCk5vdGUgdGhhdCB3ZSBoYXZlIHRoZSBmaXJzdCBwYXJ0IG9mIHRoZSBhYm92
ZSB3L2EgYWxyZWFkeSBpbXBsZW1lbnRlZA0KaW4gaTgzMF9pbml0X2Nsb2NrX2dhdGluZyAtIGxl
YXZlIHRoYXQgYXMtaXMgdG8gYXZvaWQgc3VycHJpc2VzLg0KDQp2MjogQWRkIGEgY29tbWVudCBp
biB0aGUgY29kZS4NCg0KQnVnemlsbGE6IGh0dHBzOi8vYnVncy5mcmVlZGVza3RvcC5vcmcvc2hv
d19idWcuY2dpP2lkPTQ3ODI3DQpUZXN0ZWQtYnk6IFJoeXMgPHJoeXNwdWtAZ21haWwuY29tPg0K
UmV2aWV3ZWQtYnk6IENocmlzIFdpbHNvbiA8Y2hyaXNAY2hyaXMtd2lsc29uLmNvLnVrPg0KU2ln
bmVkLW9mZi1ieTogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4NCltid2g6
IEJhY2twb3J0ZWQgdG8gMy4yOg0KIC0gQWRqdXN0IGNvbnRleHQNCiAtIHMvaW50ZWxfcmluZ19l
bWl0KHJpbmcsIC9PVVRfUklORygvXQ0KU2lnbmVkLW9mZi1ieTogQmVuIEh1dGNoaW5ncyA8YmVu
QGRlY2FkZW50Lm9yZy51az4NCi0tLQ0KIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX292ZXJs
YXkuYyB8ICAgMTQgKysrKysrKysrKystLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkNCg0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxf
b3ZlcmxheS5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9vdmVybGF5LmMNCkBA
IC00MjgsOSArNDI4LDE3IEBAIHN0YXRpYyBpbnQgaW50ZWxfb3ZlcmxheV9vZmYoc3RydWN0IGlu
dGUNCiAJT1VUX1JJTkcoZmxpcF9hZGRyKTsNCiAJT1VUX1JJTkcoTUlfV0FJVF9GT1JfRVZFTlQg
fCBNSV9XQUlUX0ZPUl9PVkVSTEFZX0ZMSVApOw0KIAkvKiB0dXJuIG92ZXJsYXkgb2ZmICovDQot
CU9VVF9SSU5HKE1JX09WRVJMQVlfRkxJUCB8IE1JX09WRVJMQVlfT0ZGKTsNCi0JT1VUX1JJTkco
ZmxpcF9hZGRyKTsNCi0JT1VUX1JJTkcoTUlfV0FJVF9GT1JfRVZFTlQgfCBNSV9XQUlUX0ZPUl9P
VkVSTEFZX0ZMSVApOw0KKwlpZiAoSVNfSTgzMChkZXYpKSB7DQorCQkvKiBXb3JrYXJvdW5kOiBE
b24ndCBkaXNhYmxlIHRoZSBvdmVybGF5IGZ1bGx5LCBzaW5jZSBvdGhlcndpc2UNCisJCSAqIGl0
IGRpZXMgb24gdGhlIG5leHQgT1ZFUkxBWV9PTiBjbWQuICovDQorCQlPVVRfUklORyhNSV9OT09Q
KTsNCisJCU9VVF9SSU5HKE1JX05PT1ApOw0KKwkJT1VUX1JJTkcoTUlfTk9PUCk7DQorCX0gZWxz
ZSB7DQorCQlPVVRfUklORyhNSV9PVkVSTEFZX0ZMSVAgfCBNSV9PVkVSTEFZX09GRik7DQorCQlP
VVRfUklORyhmbGlwX2FkZHIpOw0KKwkJT1VUX1JJTkcoTUlfV0FJVF9GT1JfRVZFTlQgfCBNSV9X
QUlUX0ZPUl9PVkVSTEFZX0ZMSVApOw0KKwl9DQogCUFEVkFOQ0VfTFBfUklORygpOw0KIA0KIAly
ZXR1cm4gaW50ZWxfb3ZlcmxheV9kb193YWl0X3JlcXVlc3Qob3ZlcmxheSwgcmVxdWVzdCwNCg==


--=-wm9jYJgplu2kdSmE36k3--

--=-8MifrlCffLB+NiLm0Qf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKZmT+e/yOyVhhEJAQqj6Q//Y5hvvSzyBvGrr6TvLBjIbTwt4IB43ajH
QaQn1X8z76I77qMb1qPn7owAuqsojL3wEWTZuPSAuB5asQbr+jrMkuJ3CVIpesiG
5zDfvkL2sCRBPYmbN3xJ2PHR6K+0b6zs7FYKnpJ95lSNKhsMZJVkVw5awXBorM9+
/n3i48kcCIZOMF9ElnEJG3+G/It5YOlmWuXpQzy4cRHDJ5VuU9pyTT5PJmqK0A1R
fiQsEBLn9Wyi0jIA9mFqhSjP7oIM2VQMyzAet0krYx0cJHB2Hgpt63/vaikLjjko
mNCHXdpqB4IupV+vI6CUpPolZIuarhAwU2FBgGnPP8m9fdt8wyBS3vjWD3bxcS/G
tsq2h7IYKwhgcl1tIFF3AqLuZzGJWOGtHUxt8QxadgBR4zp90N4jBDHCAGQ1q7Yd
Mm2zZTieM9ljnHMpsrgGLQaz/xNX974GOP3KJNuuk1x6V+lv2n5Q0D//vHNTOkfp
kK8hkODJKziWujKvqhanHtg6+scJnb4uyedC2mqUcBxauYJnCW9GKYcKLFMEh2Kg
za2TTpq0KH8lmD2OhWK+wqbnvYASBq1oO0f5W1YybiUrs8Kstp34cWa5ZxAi9/Ct
AOD4EF6jBJTiOcgbWHBEpZ/Fa1KQcqr7kNpgnJNqzjBgcdu/xoGSlGI4tau9PGWQ
fBJTM0FrxRI=
=degM
-----END PGP SIGNATURE-----

--=-8MifrlCffLB+NiLm0Qf6--
