Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2KPQR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:17:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50573 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598Ab2KPQRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:17:24 -0500
Message-ID: <1353082639.4867.89.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 31/66] NFS: Wait for session recovery to finish before
 returning
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Fri, 16 Nov 2012 16:17:19 +0000
In-Reply-To: <20121115040941.255779659@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
	 <20121115040941.255779659@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9PMW31PAvq77R51bm3Ev"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9PMW31PAvq77R51bm3Ev
Content-Type: multipart/mixed; boundary="=-fbSkj6V6exJwrkQJk2B+"


--=-fbSkj6V6exJwrkQJk2B+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-14 at 20:10 -0800, Greg Kroah-Hartman wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Bryan Schumaker <bjschuma@netapp.com>
>=20
> commit 399f11c3d872bd748e1575574de265a6304c7c43 upstream.
[...]

Also not applied to 3.0 and 3.4; here's my version for 3.2 which is
probably usable for at least one of those.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-fbSkj6V6exJwrkQJk2B+
Content-Disposition: attachment;
	filename*0=nfs-wait-for-session-recovery-to-finish-before-returning.patc;
	filename*1=h
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="nfs-wait-for-session-recovery-to-finish-before-returning.patch";
	charset="UTF-8"

RnJvbTogQnJ5YW4gU2NodW1ha2VyIDxianNjaHVtYUBuZXRhcHAuY29tPg0KRGF0ZTogVHVlLCAz
MCBPY3QgMjAxMiAxNjowNjozNSAtMDQwMA0KU3ViamVjdDogTkZTOiBXYWl0IGZvciBzZXNzaW9u
IHJlY292ZXJ5IHRvIGZpbmlzaCBiZWZvcmUgcmV0dXJuaW5nDQoNCmNvbW1pdCAzOTlmMTFjM2Q4
NzJiZDc0OGUxNTc1NTc0ZGUyNjVhNjMwNGM3YzQzIHVwc3RyZWFtLg0KDQpDdXJyZW50bHksIHdl
IHdpbGwgc2NoZWR1bGUgc2Vzc2lvbiByZWNvdmVyeSBhbmQgdGhlbiByZXR1cm4gdG8gdGhlDQpj
YWxsZXIgb2YgbmZzNF9oYW5kbGVfZXhjZXB0aW9uLiAgVGhpcyB3b3JrcyBmb3IgbW9zdCBjYXNl
cywgYnV0IGNhdXNlcw0KYSBoYW5nIG9uIHRoZSBmb2xsb3dpbmcgdGVzdCBjYXNlOg0KDQoJQ2xp
ZW50CQkJCVNlcnZlcg0KCS0tLS0tLQkJCQktLS0tLS0NCglPcGVuIGZpbGUgb3ZlciBORlMgdjQu
MQ0KCVdyaXRlIHRvIGZpbGUNCgkJCQkJRXhwaXJlIGNsaWVudA0KCVRyeSB0byBsb2NrIGZpbGUN
Cg0KVGhlIHNlcnZlciB3aWxsIHJldHVybiBORlM0RVJSX0JBRFNFU1NJT04sIHByb21wdGluZyB0
aGUgY2xpZW50IHRvDQpzY2hlZHVsZSByZWNvdmVyeS4gIEhvd2V2ZXIsIHRoZSBjbGllbnQgd2ls
bCBjb250aW51ZSBwbGFjaW5nIGxvY2sNCmF0dGVtcHRzIGFuZCB0aGUgb3BlbiByZWNvdmVyeSBu
ZXZlciBzZWVtcyB0byBiZSBzY2hlZHVsZWQuICBUaGUNCnNpbXBsZXN0IHNvbHV0aW9uIGlzIHRv
IHdhaXQgZm9yIHNlc3Npb24gcmVjb3ZlcnkgdG8gcnVuIGJlZm9yZSByZXRyeWluZw0KdGhlIGxv
Y2suDQoNClNpZ25lZC1vZmYtYnk6IEJyeWFuIFNjaHVtYWtlciA8YmpzY2h1bWFAbmV0YXBwLmNv
bT4NClNpZ25lZC1vZmYtYnk6IFRyb25kIE15a2xlYnVzdCA8VHJvbmQuTXlrbGVidXN0QG5ldGFw
cC5jb20+DQpbYndoOiBCYWNrcG9ydGVkIHRvIDMuMjogYWRqdXN0IGNvbnRleHRdDQpTaWduZWQt
b2ZmLWJ5OiBCZW4gSHV0Y2hpbmdzIDxiZW5AZGVjYWRlbnQub3JnLnVrPg0KLS0tDQogZnMvbmZz
L25mczRwcm9jLmMgfCAgICAzICstLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MiBkZWxldGlvbnMoLSkNCg0KLS0tIGEvZnMvbmZzL25mczRwcm9jLmMNCisrKyBiL2ZzL25mcy9u
ZnM0cHJvYy5jDQpAQCAtMzAzLDggKzMwMyw3IEBAIHN0YXRpYyBpbnQgbmZzNF9oYW5kbGVfZXhj
ZXB0aW9uKHN0cnVjdA0KIAkJCWRwcmludGsoIiVzIEVSUk9SOiAlZCBSZXNldCBzZXNzaW9uXG4i
LCBfX2Z1bmNfXywNCiAJCQkJZXJyb3Jjb2RlKTsNCiAJCQluZnM0X3NjaGVkdWxlX3Nlc3Npb25f
cmVjb3ZlcnkoY2xwLT5jbF9zZXNzaW9uKTsNCi0JCQlleGNlcHRpb24tPnJldHJ5ID0gMTsNCi0J
CQlicmVhazsNCisJCQlnb3RvIHdhaXRfb25fcmVjb3Zlcnk7DQogI2VuZGlmIC8qIGRlZmluZWQo
Q09ORklHX05GU19WNF8xKSAqLw0KIAkJY2FzZSAtTkZTNEVSUl9GSUxFX09QRU46DQogCQkJaWYg
KGV4Y2VwdGlvbi0+dGltZW91dCA+IEhaKSB7DQo=


--=-fbSkj6V6exJwrkQJk2B+--

--=-9PMW31PAvq77R51bm3Ev
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKZnD+e/yOyVhhEJAQqujw/+Lg/BAZ3IyWbmCumfcBRIob/8mUj63wGs
+8Hssmw2kLTOludzEzG+ZjWuveSOFhc3XnaDtAt2CZB0HFQyRE30niuQW//tIXvA
FCB7XWrMvrrfNbAmWBpU53AwsnDCiNqqPHfZDgjUoSkWdxKmIzpC3W4snfpkV56W
Jk7i5OquJ6OB/WsLJVThV7BzjfJPL9w2Lfle9Ce7vnY0c7yoHMVXYDXLXF0RcJVf
qycK4asRpj4pvCiWNGxEi22dSYmrySDupFEnza8ZrfYu1siz2/fCudD/ELNYO89O
q68erjC8XnmzuT/0CSRO/oovntOMwjr6AXqdf69Egms8UIhxGQapcdubr6ff15a2
I7J+jGVPethgFS3Goa84ofApJpFMCPUYelevW8FsiJB7oV5iuhzMg+LBUnkzEciQ
fomQc8FblQ7NJFnm74dLtQJYTOaIq53zbjDgK0r3u9aNELAm1fze+hCW/ALgJB9t
lH/LBd/ncyq5IQYlnESumLPeGmVjM280oSzg+fQq5zNO1Ku0RvIF+MgYbqR7h5af
B/NCAXgflWy68I8QxMHkM04Ysn0+2wKpnL7KPopDVVFLKAlth5uvEUgWtRWqNyut
7MT0uWDfsIGZg+M8Y80GZcuFMYjbfRGUq9psykbKRsfXFqtLyAS8E+GzeLxHqB99
ICAkee3K+SU=
=gUUI
-----END PGP SIGNATURE-----

--=-9PMW31PAvq77R51bm3Ev--
