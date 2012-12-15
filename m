Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab2LOT5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 14:57:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47561 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab2LOT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 14:57:05 -0500
Message-ID: <1355601411.18807.26.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 152/241] mm: vmscan: fix endless loop in kswapd balancing
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Dec 2012 19:56:51 +0000
In-Reply-To: <1355407206-17100-153-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-153-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QUiG4f/UBJw1HcSBCoXn"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QUiG4f/UBJw1HcSBCoXn
Content-Type: multipart/mixed; boundary="=-tl0d15Pt/zgN/lJk5EYX"


--=-tl0d15Pt/zgN/lJk5EYX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.2 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Johannes Weiner <hannes@cmpxchg.org>
>=20
> commit 60cefed485a02bd99b6299dad70666fe49245da7 upstream.
[...]

Greg, you missed this in 3.{0,4}.y.  I'm attaching the version I used
for 3.2.y, which seems to be applicable to 3.0.y.  One or other of these
should work for 3.4.y.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-tl0d15Pt/zgN/lJk5EYX
Content-Disposition: attachment;
	filename="0001-mm-vmscan-fix-endless-loop-in-kswapd-balancing.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="0001-mm-vmscan-fix-endless-loop-in-kswapd-balancing.patch";
	charset="UTF-8"

RnJvbSAzOWQxOGRjNGI4YjBjMDAwZmE2ODFjYmFlMTBhYzNmOGExMzI4MTRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSm9oYW5uZXMgV2VpbmVyIDxoYW5uZXNAY21weGNoZy5vcmc+
DQpEYXRlOiBUaHUsIDI5IE5vdiAyMDEyIDEzOjU0OjIzIC0wODAwDQpTdWJqZWN0OiBbUEFUQ0hd
IG1tOiB2bXNjYW46IGZpeCBlbmRsZXNzIGxvb3AgaW4ga3N3YXBkIGJhbGFuY2luZw0KDQpjb21t
aXQgNjBjZWZlZDQ4NWEwMmJkOTliNjI5OWRhZDcwNjY2ZmU0OTI0NWRhNyB1cHN0cmVhbS4NCg0K
S3N3YXBkIGRvZXMgbm90IGluIGFsbCBwbGFjZXMgaGF2ZSB0aGUgc2FtZSBjcml0ZXJpYSBmb3Ig
YSBiYWxhbmNlZA0Kem9uZS4gIFpvbmVzIGFyZSBvbmx5IGJlaW5nIHJlY2xhaW1lZCB3aGVuIHRo
ZWlyIGhpZ2ggd2F0ZXJtYXJrIGlzDQpicmVhY2hlZCwgYnV0IGNvbXBhY3Rpb24gY2hlY2tzIGxv
b3Agb3ZlciB0aGUgem9uZWxpc3QgYWdhaW4gd2hlbiB0aGUNCnpvbmUgZG9lcyBub3QgbWVldCB0
aGUgbG93IHdhdGVybWFyayBwbHVzIHR3byB0aW1lcyB0aGUgc2l6ZSBvZiB0aGUNCmFsbG9jYXRp
b24uICBUaGlzIGdldHMga3N3YXBkIHN0dWNrIGluIGFuIGVuZGxlc3MgbG9vcCBvdmVyIGEgc21h
bGwNCnpvbmUsIGxpa2UgdGhlIERNQSB6b25lLCB3aGVyZSB0aGUgaGlnaCB3YXRlcm1hcmsgaXMg
c21hbGxlciB0aGFuIHRoZQ0KY29tcGFjdGlvbiByZXF1aXJlbWVudC4NCg0KQWRkIGEgZnVuY3Rp
b24sIHpvbmVfYmFsYW5jZWQoKSwgdGhhdCBjaGVja3MgdGhlIHdhdGVybWFyaywgYW5kLCBmb3IN
CmhpZ2hlciBvcmRlciBhbGxvY2F0aW9ucywgaWYgY29tcGFjdGlvbiBoYXMgZW5vdWdoIGZyZWUg
bWVtb3J5LiAgVGhlbg0KdXNlIGl0IHVuaWZvcm1seSB0byBjaGVjayBmb3IgYmFsYW5jZWQgem9u
ZXMuDQoNClRoaXMgbWFrZXMgc3VyZSB0aGF0IHdoZW4gdGhlIGNvbXBhY3Rpb24gd2F0ZXJtYXJr
IGlzIG5vdCBtZXQsIGF0IGxlYXN0DQpyZWNsYWltIGhhcHBlbnMgYW5kIHByb2dyZXNzIGlzIG1h
ZGUgLSBvciB0aGUgem9uZSBpcyBkZWNsYXJlZA0KdW5yZWNsYWltYWJsZSBhdCBzb21lIHBvaW50
IGFuZCBza2lwcGVkIGVudGlyZWx5Lg0KDQpTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBXZWluZXIg
PGhhbm5lc0BjbXB4Y2hnLm9yZz4NClJlcG9ydGVkLWJ5OiBHZW9yZ2UgU3BlbHZpbiA8bGludXhA
aG9yaXpvbi5jb20+DQpSZXBvcnRlZC1ieTogSm9oYW5uZXMgSGlydGUgPGpvaGFubmVzLmhpcnRl
QGZlbS50dS1pbG1lbmF1LmRlPg0KUmVwb3J0ZWQtYnk6IFRvbWFzIFJhY2VrIDx0cmFjZWtAcmVk
aGF0LmNvbT4NClRlc3RlZC1ieTogSm9oYW5uZXMgSGlydGUgPGpvaGFubmVzLmhpcnRlQGZlbS50
dS1pbG1lbmF1LmRlPg0KUmV2aWV3ZWQtYnk6IFJpayB2YW4gUmllbCA8cmllbEByZWRoYXQuY29t
Pg0KQ2M6IE1lbCBHb3JtYW4gPG1lbEBjc24udWwuaWU+DQpTaWduZWQtb2ZmLWJ5OiBBbmRyZXcg
TW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KU2lnbmVkLW9mZi1ieTogTGludXMg
VG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KW2J3aDogQmFja3BvcnRl
ZCB0byAzLjI6IGFkanVzdCBjb250ZXh0XQ0KU2lnbmVkLW9mZi1ieTogQmVuIEh1dGNoaW5ncyA8
YmVuQGRlY2FkZW50Lm9yZy51az4NCi0tLQ0KIG1tL3Ztc2Nhbi5jIHwgICAyNyArKysrKysrKysr
KysrKysrKystLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgOSBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL21tL3Ztc2Nhbi5jIGIvbW0vdm1zY2FuLmMNCmlu
ZGV4IDMxMzM4MWMuLjFlNGVlMWEgMTAwNjQ0DQotLS0gYS9tbS92bXNjYW4uYw0KKysrIGIvbW0v
dm1zY2FuLmMNCkBAIC0yNDkyLDYgKzI0OTIsMTkgQEAgdW5zaWduZWQgbG9uZyB0cnlfdG9fZnJl
ZV9tZW1fY2dyb3VwX3BhZ2VzKHN0cnVjdCBtZW1fY2dyb3VwICptZW1fY29udCwNCiB9DQogI2Vu
ZGlmDQogDQorc3RhdGljIGJvb2wgem9uZV9iYWxhbmNlZChzdHJ1Y3Qgem9uZSAqem9uZSwgaW50
IG9yZGVyLA0KKwkJCSAgdW5zaWduZWQgbG9uZyBiYWxhbmNlX2dhcCwgaW50IGNsYXNzem9uZV9p
ZHgpDQorew0KKwlpZiAoIXpvbmVfd2F0ZXJtYXJrX29rX3NhZmUoem9uZSwgb3JkZXIsIGhpZ2hf
d21hcmtfcGFnZXMoem9uZSkgKw0KKwkJCQkgICAgYmFsYW5jZV9nYXAsIGNsYXNzem9uZV9pZHgs
IDApKQ0KKwkJcmV0dXJuIGZhbHNlOw0KKw0KKwlpZiAoQ09NUEFDVElPTl9CVUlMRCAmJiBvcmRl
ciAmJiAhY29tcGFjdGlvbl9zdWl0YWJsZSh6b25lLCBvcmRlcikpDQorCQlyZXR1cm4gZmFsc2U7
DQorDQorCXJldHVybiB0cnVlOw0KK30NCisNCiAvKg0KICAqIHBnZGF0X2JhbGFuY2VkIGlzIHVz
ZWQgd2hlbiBjaGVja2luZyBpZiBhIG5vZGUgaXMgYmFsYW5jZWQgZm9yIGhpZ2gtb3JkZXINCiAg
KiBhbGxvY2F0aW9ucy4gT25seSB6b25lcyB0aGF0IG1lZXQgd2F0ZXJtYXJrcyBhbmQgYXJlIGlu
IGEgem9uZSBhbGxvd2VkDQpAQCAtMjU1MSw4ICsyNTY0LDcgQEAgc3RhdGljIGJvb2wgc2xlZXBp
bmdfcHJlbWF0dXJlbHkocGdfZGF0YV90ICpwZ2RhdCwgaW50IG9yZGVyLCBsb25nIHJlbWFpbmlu
ZywNCiAJCQljb250aW51ZTsNCiAJCX0NCiANCi0JCWlmICghem9uZV93YXRlcm1hcmtfb2tfc2Fm
ZSh6b25lLCBvcmRlciwgaGlnaF93bWFya19wYWdlcyh6b25lKSwNCi0JCQkJCQkJaSwgMCkpDQor
CQlpZiAoIXpvbmVfYmFsYW5jZWQoem9uZSwgb3JkZXIsIDAsIGkpKQ0KIAkJCWFsbF96b25lc19v
ayA9IGZhbHNlOw0KIAkJZWxzZQ0KIAkJCWJhbGFuY2VkICs9IHpvbmUtPnByZXNlbnRfcGFnZXM7
DQpAQCAtMjY1NSw4ICsyNjY3LDcgQEAgbG9vcF9hZ2FpbjoNCiAJCQkJc2hyaW5rX2FjdGl2ZV9s
aXN0KFNXQVBfQ0xVU1RFUl9NQVgsIHpvbmUsDQogCQkJCQkJCSZzYywgcHJpb3JpdHksIDApOw0K
IA0KLQkJCWlmICghem9uZV93YXRlcm1hcmtfb2tfc2FmZSh6b25lLCBvcmRlciwNCi0JCQkJCWhp
Z2hfd21hcmtfcGFnZXMoem9uZSksIDAsIDApKSB7DQorCQkJaWYgKCF6b25lX2JhbGFuY2VkKHpv
bmUsIG9yZGVyLCAwLCAwKSkgew0KIAkJCQllbmRfem9uZSA9IGk7DQogCQkJCWJyZWFrOw0KIAkJ
CX0gZWxzZSB7DQpAQCAtMjcxNyw5ICsyNzI4LDggQEAgbG9vcF9hZ2FpbjoNCiAJCQkJKHpvbmUt
PnByZXNlbnRfcGFnZXMgKw0KIAkJCQkJS1NXQVBEX1pPTkVfQkFMQU5DRV9HQVBfUkFUSU8tMSkg
Lw0KIAkJCQlLU1dBUERfWk9ORV9CQUxBTkNFX0dBUF9SQVRJTyk7DQotCQkJaWYgKCF6b25lX3dh
dGVybWFya19va19zYWZlKHpvbmUsIG9yZGVyLA0KLQkJCQkJaGlnaF93bWFya19wYWdlcyh6b25l
KSArIGJhbGFuY2VfZ2FwLA0KLQkJCQkJZW5kX3pvbmUsIDApKSB7DQorCQkJaWYgKCF6b25lX2Jh
bGFuY2VkKHpvbmUsIG9yZGVyLA0KKwkJCQkJICAgYmFsYW5jZV9nYXAsIGVuZF96b25lKSkgew0K
IAkJCQlzaHJpbmtfem9uZShwcmlvcml0eSwgem9uZSwgJnNjKTsNCiANCiAJCQkJcmVjbGFpbV9z
dGF0ZS0+cmVjbGFpbWVkX3NsYWIgPSAwOw0KQEAgLTI3NDYsOCArMjc1Niw3IEBAIGxvb3BfYWdh
aW46DQogCQkJCWNvbnRpbnVlOw0KIAkJCX0NCiANCi0JCQlpZiAoIXpvbmVfd2F0ZXJtYXJrX29r
X3NhZmUoem9uZSwgb3JkZXIsDQotCQkJCQloaWdoX3dtYXJrX3BhZ2VzKHpvbmUpLCBlbmRfem9u
ZSwgMCkpIHsNCisJCQlpZiAoIXpvbmVfYmFsYW5jZWQoem9uZSwgb3JkZXIsIDAsIGVuZF96b25l
KSkgew0KIAkJCQlhbGxfem9uZXNfb2sgPSAwOw0KIAkJCQkvKg0KIAkJCQkgKiBXZSBhcmUgc3Rp
bGwgdW5kZXIgbWluIHdhdGVyIG1hcmsuICBUaGlzDQo=


--=-tl0d15Pt/zgN/lJk5EYX--

--=-QUiG4f/UBJw1HcSBCoXn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMzWBOe/yOyVhhEJAQpyLA/9E7Em4Jh7m3xe9goQ2tCnRkH+CSliD8b6
kMufaVV7TJ5Sy77+a4m+sKN9HuMvGzZbDYBd6zV4zRDG9YHGwaMQ9UKfr75tEHK0
k1mZtbjq2su996v2EXfe1OWK5w+Jtdzzx0w90uRcwVnMIMkH5mCcT8mwRHmAWbeQ
i47/GvXg5xp5nphazhP13UApFU9peJwPxfRetROUb6fKlm8cG4JMMQzJc0ZZHprL
jY5U3+VjDOVQMorT6wpHUCFi0wxidnru3GqUvR+IU/D8gl1YMSzVcSXALr4Wcl4V
B9F8AurQ5A1kYhdiOgjN9i/4iN5uxGaMLVBZBuUgtDWycGJZmGcmLhNktOyP6Xpn
ApDZM/QBEc2zW7kmqx/The17+B5emkP2qzSIQTLHVBHCedWzcgaub7ZD+Sym80ag
pZIZLQ6ftyQghktSsS+M7fw4nHgsRwcgLFlb5hZ9mPjJFjQub0Q0ZPyigi3CoBA9
QqskOaYt+ILMMchFFvgVd5plEvQAJ/7pDDyZ0/ObK5HQ8ZrrrmMDk8VjCetRJmIk
4TZZK2p5EK9Jr+oO09PakmT9ykkC/qHT77Sp/FQYWlM1in07WNgPmO239doSdd7N
AeGMWXoY/JAE5ESOxPvm3RGzzDuQPrmA3g3vgIiEbJHV29C3jUQ9fqzaea6V84NX
WhucBwekTfg=
=AFBd
-----END PGP SIGNATURE-----

--=-QUiG4f/UBJw1HcSBCoXn--
