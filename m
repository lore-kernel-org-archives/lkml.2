Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2FHC2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:28:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760383Ab2FHC2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:28:07 -0400
Message-ID: <1339122472.21665.103.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 53/82] asix: allow full size 8021Q frames to be received
From: Ben Hutchings <ben@decadent.org.uk>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@linuxfoundation.org>,
        Trond Wuellner <trond@chromium.org>, Paul Stewart <pstew@chromium.org>,
        Grant Grundler <grundler@chromium.org>, Allan Chou <allan@asix.com.tw>
Date: Fri, 08 Jun 2012 03:27:52 +0100
In-Reply-To: <20120607040344.002169511@linuxfoundation.org>
References: <20120607040344.002169511@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-26O5fHiWWSYq+g9uwfH5"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-26O5fHiWWSYq+g9uwfH5
Content-Type: multipart/mixed; boundary="=-VAp6vp5/5rNjS+QQyLwO"


--=-VAp6vp5/5rNjS+QQyLwO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-07 at 13:04 +0900, Greg KH wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
>=20
> From: Eric Dumazet <edumazet@google.com>
>=20
> [ Upstream commit 9dae31009b1a00d926c6fe032d5a88099620adc3 ]
>=20
> asix driver drops 8021Q full size frames because it doesn't take into
> account VLAN header size.
>=20
> Tested on AX88772 adapter.
[...]

This should presumably go into earlier stable versions as well
(specifically requested for 3.2 in <http://bugs.debian.org/676545>).

Does the attached backport look reasonable?

Ben.

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-VAp6vp5/5rNjS+QQyLwO
Content-Disposition: attachment;
	filename="asix-allow-full-size-8021q-frames-to-be-received.patch"
Content-Type: text/x-patch;
	name="asix-allow-full-size-8021q-frames-to-be-received.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbTogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPg0KRGF0ZTogTW9uLCAyOCBN
YXkgMjAxMiAyMjozMTo0MSArMDAwMA0KU3ViamVjdDogYXNpeDogYWxsb3cgZnVsbCBzaXplIDgw
MjFRIGZyYW1lcyB0byBiZSByZWNlaXZlZA0KDQpjb21taXQgOWRhZTMxMDA5YjFhMDBkOTI2YzZm
ZTAzMmQ1YTg4MDk5NjIwYWRjMyB1cHN0cmVhbS4NCg0KYXNpeCBkcml2ZXIgZHJvcHMgODAyMVEg
ZnVsbCBzaXplIGZyYW1lcyBiZWNhdXNlIGl0IGRvZXNuJ3QgdGFrZSBpbnRvDQphY2NvdW50IFZM
QU4gaGVhZGVyIHNpemUuDQoNClRlc3RlZCBvbiBBWDg4NzcyIGFkYXB0ZXIuDQoNClNpZ25lZC1v
ZmYtYnk6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCkNDOiBHcmVnIEtyb2Fo
LUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KQ0M6IEFsbGFuIENob3UgPGFs
bGFuQGFzaXguY29tLnR3Pg0KQ0M6IFRyb25kIFd1ZWxsbmVyIDx0cm9uZEBjaHJvbWl1bS5vcmc+
DQpDQzogR3JhbnQgR3J1bmRsZXIgPGdydW5kbGVyQGNocm9taXVtLm9yZz4NCkNDOiBQYXVsIFN0
ZXdhcnQgPHBzdGV3QGNocm9taXVtLm9yZz4NClNpZ25lZC1vZmYtYnk6IERhdmlkIFMuIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCltid2g6IEJhY2twb3J0ZWQgdG8gMy4yOiBubyBvZmZz
ZXQgdXNlZCBpbiBhc2l4X3J4X2ZpeHVwKCldDQpTaWduZWQtb2ZmLWJ5OiBCZW4gSHV0Y2hpbmdz
IDxiZW5AZGVjYWRlbnQub3JnLnVrPg0KLS0tDQotLS0gYS9kcml2ZXJzL25ldC91c2IvYXNpeC5j
DQorKysgYi9kcml2ZXJzL25ldC91c2IvYXNpeC5jDQpAQCAtMzUsNiArMzUsNyBAQA0KICNpbmNs
dWRlIDxsaW51eC9jcmMzMi5oPg0KICNpbmNsdWRlIDxsaW51eC91c2IvdXNibmV0Lmg+DQogI2lu
Y2x1ZGUgPGxpbnV4L3NsYWIuaD4NCisjaW5jbHVkZSA8bGludXgvaWZfdmxhbi5oPg0KIA0KICNk
ZWZpbmUgRFJJVkVSX1ZFUlNJT04gIjA4LU5vdi0yMDExIg0KICNkZWZpbmUgRFJJVkVSX05BTUUg
ImFzaXgiDQpAQCAtMzQ4LDcgKzM0OSw3IEBADQogCQkJcmV0dXJuIDI7DQogCQl9DQogDQotCQlp
ZiAoc2l6ZSA+IGRldi0+bmV0LT5tdHUgKyBFVEhfSExFTikgew0KKwkJaWYgKHNpemUgPiBkZXYt
Pm5ldC0+bXR1ICsgRVRIX0hMRU4gKyBWTEFOX0hMRU4pIHsNCiAJCQluZXRkZXZfZXJyKGRldi0+
bmV0LCAiYXNpeF9yeF9maXh1cCgpIEJhZCBSWCBMZW5ndGggJWRcbiIsDQogCQkJCSAgIHNpemUp
Ow0KIAkJCXJldHVybiAwOw0K


--=-VAp6vp5/5rNjS+QQyLwO--

--=-26O5fHiWWSYq+g9uwfH5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9FjKOe/yOyVhhEJAQpTBw/9EYqVVVMuAayICPhrhUW9ItD60GV6+0Hb
gO0quvut2GQy2atlEjqbrIgVh6YOvB/SyHKeFWbJwSV0cw/8wBBAAdGQ5QXl//hN
JIv5ebanLMgwrWig6rRvXIVE4Klp7pXY7vjEzEz3ohfJsLzpqEqZrYOkjs5EtqVs
DqSoWDiYJOJGEgxBY+SHu0D1ZYQ61Hkv3cUSTBzNBCIeBHyoWPO9YEntCP4udSkd
aV7vgDCjTOkllKkY0A6GAvoHY+CO4nLZzhG/z7gUKIntLYru4w0dLtitaGFsJRhk
WCdpK+qDuzZ+7F7//8bFZF3LXK+IxQcu8tl5ia+78qR77cWJLkrcgfhPOpUr/2Aq
8pXsiN1FG/GRKu4xNgxKpP0bz6P3WXSYAA53ewB5U/GCNSOdu2JHoB/YFP/ItHrF
s9SceNS7ot58lmG8hbnKPLQFGID0yPTq59SQbHJB/KXrUZoQW8OreJEAvvSFQNYB
60ko+RnN554MnYKvg3GYjPwOH/2Iq6AN9UcMyVL34RvVTjDl+ENRArxiRNQvhFyv
vCOOTrk7N8suz0yNo91XBZ0UD8dS1ZRH1IkbTwLaLy5hzq2mHEgcM1vsoj3IujO8
NHte2mZr3R8iAnf+5fLHGQY8Tvo44Vb0J1l5fddMY8nSsp/FjVpQAq2Tq2hpZf+Y
t9/8V2KxQZc=
=kDbH
-----END PGP SIGNATURE-----

--=-26O5fHiWWSYq+g9uwfH5--
