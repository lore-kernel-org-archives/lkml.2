Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2LOULq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:11:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47668 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271Ab2LOULp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:11:45 -0500
Message-ID: <1355602292.18807.31.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 167/241] SUNRPC: Set alloc_slot for backchannel tcp ops
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Sat, 15 Dec 2012 20:11:32 +0000
In-Reply-To: <1355407206-17100-168-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-168-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BxP3L7qa/3eqtTPi31iH"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BxP3L7qa/3eqtTPi31iH
Content-Type: multipart/mixed; boundary="=-XwvyrltJDvPiNu8AlOXV"


--=-XwvyrltJDvPiNu8AlOXV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.2 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Bryan Schumaker <bjschuma@netapp.com>
>=20
> commit 84e28a307e376f271505af65a7b7e212dd6f61f4 upstream.
>=20
> f39c1bfb5a03e2d255451bff05be0d7255298fa4 (SUNRPC: Fix a UDP transport
> regression) introduced the "alloc_slot" function for xprt operations,
> but never created one for the backchannel operations.  This patch fixes
> a null pointer dereference when mounting NFS over v4.1.
[...]

Greg, you missed this in 3.4.y.  It might need a context fix; I'm
attaching the version I used for 3.2.y.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-XwvyrltJDvPiNu8AlOXV
Content-Disposition: attachment; filename="sunrpc-set-alloc_slot-for-backchannel-tcp-ops.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="sunrpc-set-alloc_slot-for-backchannel-tcp-ops.patch";
	charset="UTF-8"

RnJvbTogQnJ5YW4gU2NodW1ha2VyIDxianNjaHVtYUBuZXRhcHAuY29tPg0KRGF0ZTogTW9uLCAy
NCBTZXAgMjAxMiAxMzozOTowMSAtMDQwMA0KU3ViamVjdDogU1VOUlBDOiBTZXQgYWxsb2Nfc2xv
dCBmb3IgYmFja2NoYW5uZWwgdGNwIG9wcw0KDQpjb21taXQgODRlMjhhMzA3ZTM3NmYyNzE1MDVh
ZjY1YTdiN2UyMTJkZDZmNjFmNCB1cHN0cmVhbS4NCg0KZjM5YzFiZmI1YTAzZTJkMjU1NDUxYmZm
MDViZTBkNzI1NTI5OGZhNCAoU1VOUlBDOiBGaXggYSBVRFAgdHJhbnNwb3J0DQpyZWdyZXNzaW9u
KSBpbnRyb2R1Y2VkIHRoZSAiYWxsb2Nfc2xvdCIgZnVuY3Rpb24gZm9yIHhwcnQgb3BlcmF0aW9u
cywNCmJ1dCBuZXZlciBjcmVhdGVkIG9uZSBmb3IgdGhlIGJhY2tjaGFubmVsIG9wZXJhdGlvbnMu
ICBUaGlzIHBhdGNoIGZpeGVzDQphIG51bGwgcG9pbnRlciBkZXJlZmVyZW5jZSB3aGVuIG1vdW50
aW5nIE5GUyBvdmVyIHY0LjEuDQoNCkNhbGwgVHJhY2U6DQogWzxmZmZmZmZmZmEwMjA3OTU3Pl0g
PyB4cHJ0X3Jlc2VydmUrMHg0Ny8weDUwIFtzdW5ycGNdDQogWzxmZmZmZmZmZmEwMjAyM2E0Pl0g
Y2FsbF9yZXNlcnZlKzB4MzQvMHg2MCBbc3VucnBjXQ0KIFs8ZmZmZmZmZmZhMDIwZTI4MD5dIF9f
cnBjX2V4ZWN1dGUrMHg5MC8weDQwMCBbc3VucnBjXQ0KIFs8ZmZmZmZmZmZhMDIwZTYxYT5dIHJw
Y19hc3luY19zY2hlZHVsZSsweDJhLzB4NDAgW3N1bnJwY10NCiBbPGZmZmZmZmZmODEwNzM1ODk+
XSBwcm9jZXNzX29uZV93b3JrKzB4MTM5LzB4NTAwDQogWzxmZmZmZmZmZjgxMDcwZTcwPl0gPyBh
bGxvY193b3JrZXIrMHg3MC8weDcwDQogWzxmZmZmZmZmZmEwMjBlNWYwPl0gPyBfX3JwY19leGVj
dXRlKzB4NDAwLzB4NDAwIFtzdW5ycGNdDQogWzxmZmZmZmZmZjgxMDczZDFlPl0gd29ya2VyX3Ro
cmVhZCsweDE1ZS8weDQ2MA0KIFs8ZmZmZmZmZmY4MTQ1YzgzOT5dID8gcHJlZW1wdF9zY2hlZHVs
ZSsweDQ5LzB4NzANCiBbPGZmZmZmZmZmODEwNzNiYzA+XSA/IHJlc2N1ZXJfdGhyZWFkKzB4MjMw
LzB4MjMwDQogWzxmZmZmZmZmZjgxMDc5NjAzPl0ga3RocmVhZCsweDkzLzB4YTANCiBbPGZmZmZm
ZmZmODE0NjVkMDQ+XSBrZXJuZWxfdGhyZWFkX2hlbHBlcisweDQvMHgxMA0KIFs8ZmZmZmZmZmY4
MTA3OTU3MD5dID8ga3RocmVhZF9mcmVlemFibGVfc2hvdWxkX3N0b3ArMHg3MC8weDcwDQogWzxm
ZmZmZmZmZjgxNDY1ZDAwPl0gPyBnc19jaGFuZ2UrMHgxMy8weDEzDQoNClNpZ25lZC1vZmYtYnk6
IEJyeWFuIFNjaHVtYWtlciA8YmpzY2h1bWFAbmV0YXBwLmNvbT4NClNpZ25lZC1vZmYtYnk6IFRy
b25kIE15a2xlYnVzdCA8VHJvbmQuTXlrbGVidXN0QG5ldGFwcC5jb20+DQpbYndoOiBCYWNrcG9y
dGVkIHRvIDMuMjogYWRqdXN0IGNvbnRleHRdDQpTaWduZWQtb2ZmLWJ5OiBCZW4gSHV0Y2hpbmdz
IDxiZW5AZGVjYWRlbnQub3JnLnVrPg0KLS0tDQogbmV0L3N1bnJwYy94cHJ0c29jay5jIHwgICAg
MSArDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQoNCi0tLSBhL25ldC9zdW5ycGMv
eHBydHNvY2suYw0KKysrIGIvbmV0L3N1bnJwYy94cHJ0c29jay5jDQpAQCAtMjQ4OCw2ICsyNDg4
LDcgQEAgc3RhdGljIHN0cnVjdCBycGNfeHBydF9vcHMgeHNfdGNwX29wcyA9DQogc3RhdGljIHN0
cnVjdCBycGNfeHBydF9vcHMgYmNfdGNwX29wcyA9IHsNCiAJLnJlc2VydmVfeHBydAkJPSB4cHJ0
X3Jlc2VydmVfeHBydCwNCiAJLnJlbGVhc2VfeHBydAkJPSB4cHJ0X3JlbGVhc2VfeHBydCwNCisJ
LmFsbG9jX3Nsb3QJCT0geHBydF9hbGxvY19zbG90LA0KIAkuYnVmX2FsbG9jCQk9IGJjX21hbGxv
YywNCiAJLmJ1Zl9mcmVlCQk9IGJjX2ZyZWUsDQogCS5zZW5kX3JlcXVlc3QJCT0gYmNfc2VuZF9y
ZXF1ZXN0LA0K


--=-XwvyrltJDvPiNu8AlOXV--

--=-BxP3L7qa/3eqtTPi31iH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMzZdOe/yOyVhhEJAQpiVw/+NITPAEo53vr1JGpzrevvxZVSTYaQsJmB
uqUs3sye1MUhXhu53LXu4J8oF56TzWR2QTCBFpzHdjyf6U9UkknVY/vAl4caBfWk
r1//xk8QKhQrqZ+H17OiREU1PS3rFr8hA17xqEJ/n59GXQ1FLhxx/k6zk12K/Opw
gromNUm0E0KuOAWldtADBZo4vIcbUvtkxoJpFLMo/V+i33we9W2s8ROoVzpVBz+o
mmYJLoLrp4fPkP/uqwOipbRL1xHW3Yff9FgRpi/WVbS71nJE2lodFdBqEOLRkuqL
TLFQ/D67oAP6kzVBAn56IWrN2FEzq0Z/56HxvNaboepp/UHfY5SAZ33upDIH9dX/
NFVlVW2cwitBNk4vzTQ/70V+fbsKUbcGRTw8ES3EedOTNd/eFXttX1luEXhzZrGM
O9xOS6wRDbAFzY+dqzEjckgC0qXCwN2NTkXoaU7SxCfYt4pVAtSIRKhuQhCIF6EY
WF/j/DSY8VzV6AoBfKwn0OgZ6to6yvYJ4WH4HyYyK7qQie8T3wvAJuM8Cu6lY4Kr
m3PfumZt6WxRI9s8NKFlG/kytSc85t2LkY/a7U/pD+DX4H7r8XH3PIMxfaTNITwu
Y33qDJZR5N3KpyxM2ZrCEwTJqRi74Q2YahJqx2znY3fKKoMz1QTR3W1FscCSTUuU
fkePrRubTdA=
=NQnD
-----END PGP SIGNATURE-----

--=-BxP3L7qa/3eqtTPi31iH--
