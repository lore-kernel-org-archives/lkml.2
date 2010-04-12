Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab0DLEnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 00:43:10 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:46847 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0DLEnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 00:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject:in-reply-to:mime-version
         :x-firegpg-version:content-type;
        b=BlmQ9fbpHZ5Y9Xe+8q0zOSWSvD1Ehx//F3dQR+Szj327zyxdmkGGk1CExGCWs0+Dnw
         oh9f3HrAJkfIGJO+lceZVJiB09C2ghybM9K9gdZUUduAS29cwr0P6H0rdtLX9i0s9JWd
         wjKcpU8SveUzDYCUKXEeXcIClLtJ8cXIuhb3Y=
From: drepper@gmail.com
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Taras Glek <tglek@mozilla.com>, Johannes Weiner <hannes@cmpxchg.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 11 Apr 2010 21:43:00 -0700 (PST)
Message-ID: <g7wssj9j6ukus9yti3UYAxe124vaj_firegpg@mail.gmail.com>
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
In-Reply-To: <20100412022704.GB5151@localhost>
MIME-Version: 1.0
X-FireGPG-Version: 0.7.10
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="-----firegpg0710eqg7wssjapncnf00no16"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
-------firegpg0710eqg7wssjapncnf00no16
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: base64

T24gU3VuLCBBcHIgMTEsIDIwMTAgYXQgMTk6MjcsIFd1IEZlbmdndWFuZyA8ZmVuZ2d1YW5nLnd1
QGludGVsLmNvbT4gd3JvdGU6DQo+IFllcywgZXZlcnkgYmluYXJ5L2xpYnJhcnkgc3RhcnRzIHdp
dGggdGhpcyA1MTJiIHJlYWQuIMKgSXQgaXMgcmVxdWVzdGVkDQo+IGJ5IGxkLnNvL2xkLWxpbnV4
LnNvLCBhbmQgd2lsbCB0cmlnZ2VyIGEgNC1wYWdlIHJlYWRhaGVhZC4gVGhpcyBpcyBub3QNCj4g
Z29vZCByZWFkYWhlYWQuIEkgd29uZGVyIGlmIGxkLnNvIGNhbiBzd2l0Y2ggdG8gbW1hcCByZWFk
IGZvciB0aGUNCj4gZmlyc3QgcmVhZCwgaW4gb3JkZXIgdG8gdHJpZ2dlciBhIGxhcmdlciAxMjhr
YiByZWFkYWhlYWQuDQoNCldlIGZpcnN0IG5lZWQgdG8ga25vdyB0aGUgc2l6ZXMgb2YgdGhlIHNl
Z21lbnRzIGFuZCB0aGVpciBsb2NhdGlvbiBpbiB0aGUgYmluYXJ5LiAgVGhlIGJpbmFyaWVzIHdl
IHVzZSBub3cgYXJlIHNvbWV3aGF0IHdlbGwgbGFpZCBvdXQuICBUaGUgcmVhZC1vbmx5IHNlZ21l
bnQgc3RhcnRzIGF0IG9mZnNldCAwIGV0Yy4gIEJ1dCB0aGlzIGRvZXNuJ3QgaGF2ZSB0byBiZSB0
aGUgY2FzZS4gIFRoZSBkeW5hbWljIGxpbmtlciBoYXMgdG8gYmUgZ2VuZXJpYy4gIEFsc28sIGV2
ZW4gaWYgd2Ugc3RhcnQgbWFwcGluZyBhdCBvZmZzZXQgemVybywgbm93IG11Y2ggdG8gbWFwPyAg
VGhlIGZpbGUgbWlnaHQgY29udGFpbiBkZWJ1ZyBpbmZvIHdoaWNoIG11c3Qgbm90IGJlIG1hcHBl
ZC4gIFRoZXJlZm9yZSB0aGUgZmlyc3QgcmVhZCBsb2FkcyBlbm91Z2ggb2YgdGhlIGhlYWRlcnMg
dG8gbWFrZSBhbGwgb2YgdGhlIGRlY2lzaW9ucy4gIFllcywgd2UgY291bGQgZG8gYSBtbWFwIG9m
IG9uZSBwYWdlIGluc3RlYWQgb2YgdGhlIHJlYWQuICBCdXQgdGhhdCdzIG1vcmUgZXhwYW5zaXZl
IGluIGdlbmVyYWwsIGlzbid0IGl0Pw0K
-------firegpg0710eqg7wssjapncnf00no16
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Use GnuPG with Firefox : http://getfiregpg.org (Version: 0.7.10)

iEYEARECAAYFAkvCpNgACgkQ2ijCOnn/RHSKcgCgvg8RKXvt0BsxR2Y4MWCgFGJY
kocAoM5Roenw3eeJwXzQC+yq6Est5uyw
=yHpJ
-----END PGP SIGNATURE-----

-------firegpg0710eqg7wssjapncnf00no16--

