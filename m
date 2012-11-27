Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2K0PFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:05:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43397 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373Ab2K0PFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:05:31 -0500
Message-ID: <1354028720.4266.55.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 055/270] ARM: OMAP: counter: add locking to
 read_persistent_clock
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Colin Cross <ccross@android.com>,
        R Sricharan <r.sricharan@ti.com>, Tony Lindgren <tony@atomide.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 15:05:20 +0000
In-Reply-To: <1353949160-26803-56-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-56-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-E/cb76iOswNO4ig2+1FT"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E/cb76iOswNO4ig2+1FT
Content-Type: multipart/mixed; boundary="=-+pfkQzamkESVKBe5QTCo"


--=-+pfkQzamkESVKBe5QTCo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Colin Cross <ccross@android.com>
>=20
> commit 9d7d6e363b06934221b81a859d509844c97380df upstream.
>=20
> read_persistent_clock uses a global variable, use a spinlock to
> ensure non-atomic updates to the variable don't overlap and cause
> time to move backwards.
>=20
> Signed-off-by: Colin Cross <ccross@android.com>
> Signed-off-by: R Sricharan <r.sricharan@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
[...]

This is also missing from 3.4.  I'm attaching the adjusted version for
3.2, which looks like it will work for 3.4.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-+pfkQzamkESVKBe5QTCo
Content-Disposition: attachment;
	filename="arm-omap-counter-add-locking-to-read_persistent_clock.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="arm-omap-counter-add-locking-to-read_persistent_clock.patch";
	charset="UTF-8"

RnJvbTogQ29saW4gQ3Jvc3MgPGNjcm9zc0BhbmRyb2lkLmNvbT4NCkRhdGU6IE1vbiwgOCBPY3Qg
MjAxMiAxNDowMToxMiAtMDcwMA0KU3ViamVjdDogQVJNOiBPTUFQOiBjb3VudGVyOiBhZGQgbG9j
a2luZyB0byByZWFkX3BlcnNpc3RlbnRfY2xvY2sNCg0KY29tbWl0IDlkN2Q2ZTM2M2IwNjkzNDIy
MWI4MWE4NTlkNTA5ODQ0Yzk3MzgwZGYgdXBzdHJlYW0uDQoNCnJlYWRfcGVyc2lzdGVudF9jbG9j
ayB1c2VzIGEgZ2xvYmFsIHZhcmlhYmxlLCB1c2UgYSBzcGlubG9jayB0bw0KZW5zdXJlIG5vbi1h
dG9taWMgdXBkYXRlcyB0byB0aGUgdmFyaWFibGUgZG9uJ3Qgb3ZlcmxhcCBhbmQgY2F1c2UNCnRp
bWUgdG8gbW92ZSBiYWNrd2FyZHMuDQoNClNpZ25lZC1vZmYtYnk6IENvbGluIENyb3NzIDxjY3Jv
c3NAYW5kcm9pZC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBSIFNyaWNoYXJhbiA8ci5zcmljaGFyYW5A
dGkuY29tPg0KU2lnbmVkLW9mZi1ieTogVG9ueSBMaW5kZ3JlbiA8dG9ueUBhdG9taWRlLmNvbT4N
Cltid2g6IEJhY2twb3J0ZWQgdG8gMy4yOiBhZGp1c3QgY29udGV4dF0NClNpZ25lZC1vZmYtYnk6
IEJlbiBIdXRjaGluZ3MgPGJlbkBkZWNhZGVudC5vcmcudWs+DQotLS0NCiBhcmNoL2FybS9wbGF0
LW9tYXAvY291bnRlcl8zMmsuYyB8ICAgMjEgKysrKysrKysrKysrKystLS0tLS0tDQogMSBmaWxl
IGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQoNCi0tLSBhL2FyY2gv
YXJtL3BsYXQtb21hcC9jb3VudGVyXzMyay5jDQorKysgYi9hcmNoL2FybS9wbGF0LW9tYXAvY291
bnRlcl8zMmsuYw0KQEAgLTgyLDIyICs4MiwyOSBAQCBzdGF0aWMgdm9pZCBub3RyYWNlIG9tYXBf
dXBkYXRlX3NjaGVkX2NsDQogICogbnNlY3MgYW5kIGFkZHMgdG8gYSBtb25vdG9uaWNhbGx5IGlu
Y3JlYXNpbmcgdGltZXNwZWMuDQogICovDQogc3RhdGljIHN0cnVjdCB0aW1lc3BlYyBwZXJzaXN0
ZW50X3RzOw0KLXN0YXRpYyBjeWNsZXNfdCBjeWNsZXMsIGxhc3RfY3ljbGVzOw0KK3N0YXRpYyBj
eWNsZXNfdCBjeWNsZXM7DQogc3RhdGljIHVuc2lnbmVkIGludCBwZXJzaXN0ZW50X211bHQsIHBl
cnNpc3RlbnRfc2hpZnQ7DQorc3RhdGljIERFRklORV9TUElOTE9DSyhyZWFkX3BlcnNpc3RlbnRf
Y2xvY2tfbG9jayk7DQorDQogdm9pZCByZWFkX3BlcnNpc3RlbnRfY2xvY2soc3RydWN0IHRpbWVz
cGVjICp0cykNCiB7DQogCXVuc2lnbmVkIGxvbmcgbG9uZyBuc2VjczsNCi0JY3ljbGVzX3QgZGVs
dGE7DQotCXN0cnVjdCB0aW1lc3BlYyAqdHNwID0gJnBlcnNpc3RlbnRfdHM7DQorCWN5Y2xlc190
IGxhc3RfY3ljbGVzOw0KKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KKw0KKwlzcGluX2xvY2tfaXJx
c2F2ZSgmcmVhZF9wZXJzaXN0ZW50X2Nsb2NrX2xvY2ssIGZsYWdzKTsNCiANCiAJbGFzdF9jeWNs
ZXMgPSBjeWNsZXM7DQogCWN5Y2xlcyA9IHRpbWVyXzMya19iYXNlID8gX19yYXdfcmVhZGwodGlt
ZXJfMzJrX2Jhc2UpIDogMDsNCi0JZGVsdGEgPSBjeWNsZXMgLSBsYXN0X2N5Y2xlczsNCiANCi0J
bnNlY3MgPSBjbG9ja3NvdXJjZV9jeWMybnMoZGVsdGEsIHBlcnNpc3RlbnRfbXVsdCwgcGVyc2lz
dGVudF9zaGlmdCk7DQorCW5zZWNzID0gY2xvY2tzb3VyY2VfY3ljMm5zKGN5Y2xlcyAtIGxhc3Rf
Y3ljbGVzLA0KKwkJCQkJcGVyc2lzdGVudF9tdWx0LCBwZXJzaXN0ZW50X3NoaWZ0KTsNCisNCisJ
dGltZXNwZWNfYWRkX25zKCZwZXJzaXN0ZW50X3RzLCBuc2Vjcyk7DQorDQorCSp0cyA9IHBlcnNp
c3RlbnRfdHM7DQogDQotCXRpbWVzcGVjX2FkZF9ucyh0c3AsIG5zZWNzKTsNCi0JKnRzID0gKnRz
cDsNCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcmVhZF9wZXJzaXN0ZW50X2Nsb2NrX2xvY2ss
IGZsYWdzKTsNCiB9DQogDQogaW50IF9faW5pdCBvbWFwX2luaXRfY2xvY2tzb3VyY2VfMzJrKHZv
aWQpDQo=


--=-+pfkQzamkESVKBe5QTCo--

--=-E/cb76iOswNO4ig2+1FT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULTWsOe/yOyVhhEJAQo79w//XKqiXt4z0ZFCcuexXj0Pm0Ybt02CMDa3
g8ZlYDbBQ8YTBhq4qu2td7M0ly8DS4MYPG2QgrqM+Jx7MzmXhPsLHx72WGiluFs0
eVs6WT7Vqche+SMFmg2jqozIa3R5Gidu5uHaQJ52tU59jmyCkOKbAcsujm7oM2Ie
xEnopZFdDQmXliuWUZcOgtCAxTF5d5Ev8W/ux5IExGDUaOVdeS5SzTYC4n9OIEC9
6idlbVtoPxKvls1xlKN2MRauJJVpsbOTh2TSJDVkCFkX82IZk6w664I1crz3gJ38
PNi5xRhjxc42VnoUvbw+l/7CYOTxtPagPlJLUFpca3E4yoqAIlC58BoyN314YLSi
TimDV3vmxxti1w/6ZghXvdJ2OSKVKWyPZQBS90uIEetrRmcqVP55mZ6C32wzGZd5
sLOgznPYjcRtVhZcEbUm8bKi0HZ1PNZjtUfFH+Dr7oUc34ey9A4u/VhH8d4AhSwB
qBP8f5tqlyZo9qF96BPhYvVcuQFVSbuquq69AD/ztnpRxHdCZLhT0GGntB0vU3UF
fBaxFar96fiB5lr2ICWJoBqCHM2RcWsSrB0UXA2DlaaIiDzwOQDf3XIcNr853KuR
/mGh1g8RM6yxBfIoZflFvYOas8mxj7QDBqb+Qs2XsWic1mooXkxOf4JRA3e93rMl
u+eURSq3CVk=
=hBf6
-----END PGP SIGNATURE-----

--=-E/cb76iOswNO4ig2+1FT--
