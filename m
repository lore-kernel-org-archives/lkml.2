Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0CXSet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:34:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59382 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab0CXSes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject:in-reply-to:mime-version
         :x-firegpg-version:content-type;
        b=eBW+uNp6FpDrda/U4hkPWmR2o+5TKMcTLwCWeyT94QrxszFkFt8/lpJj/ehgSt4XrM
         yXMbNQahyGO8FPJEmEgREVLiXQdXA7SDkqqsAaVLkw14rgcAtrS+pSGIe1M/pcgprkh0
         DBnnc3w/nmKq5TcOPplxlOVtImI4YWMXbb67o=
From: drepper@gmail.com
To: Brandon Black <blblack@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Date: Wed, 24 Mar 2010 11:34:42 -0700 (PST)
Message-ID: <g76h4xrt5j1pw2kk3tUYAxe124vaj_firegpg@mail.gmail.com>
Subject: Re: behavior of recvmmsg() on blocking sockets
In-Reply-To: <84621a61003241128x3afbcea1w387aeaa68c887320@mail.gmail.com>
MIME-Version: 1.0
X-FireGPG-Version: 0.7.10
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="-----firegpg0710eqg76h4xsb8fjm9dhyve"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
-------firegpg0710eqg76h4xsb8fjm9dhyve
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgMjQsIDIwMTAgYXQgMTE6MjgsIEJyYW5kb24gQmxhY2sgPGJsYmxhY2tAZ21h
aWwuY29tPiB3cm90ZToNCj4gSSBzdGlsbCB0aGluayBoYXZpbmcgYSAiYmxvY2sgdW50aWwgYXQg
bGVhc3Qgb25lIHBhY2tldCBhcnJpdmVzIiBtb2RlDQo+IGZvciByZWN2bW1zZygpIG1ha2VzIHNl
bnNlIHRob3VnaC4NCg0KSSBhZ3JlZS4gIFRoaXMgaXMgdGhlIG1vZGUgSSd2ZSBzZWVuIHBlb3Bs
ZSBhc2tpbmcgZm9yLiAgVGhleSB3YW50IHRoZSBjYWxsIHRvIHJldHVybiBhcyBxdWlja2x5IGFz
IHBvc3NpYmxlIGlmIHRoZXJlIGlzIGRhdGEgYW5kIHRoZW4gd2l0aCBhcyBtYW55IG1lc3NhZ2Vz
IGFzIHBvc3NpYmxlLiAgQSBNU0dfV0FJVEZPUk9ORSBmbGFnIHdvdWxkIGRvIHRoZSB0cmljayBu
aWNlbHku
-------firegpg0710eqg76h4xsb8fjm9dhyve
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Use GnuPG with Firefox : http://getfiregpg.org (Version: 0.7.10)

iEYEARECAAYFAkuqW0IACgkQ2ijCOnn/RHQjqACeKXqTCNFj9NhTiLnDXNP98PsW
DAgAn0bKeaKOWrUM/TT15YuGTGSRtfTt
=5z7g
-----END PGP SIGNATURE-----

-------firegpg0710eqg76h4xsb8fjm9dhyve--

