Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0CXNtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:49:51 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34859 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab0CXNtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject:in-reply-to:mime-version
         :x-firegpg-version:content-type;
        b=xj3YBtkPLT9Pqh8sWknDui8h5o6r6Rah4qk6McsSXJoSK76ujDTsIt5a5RFZfI4jAo
         Y2HDXRB/e4LUUWrRbPdRaZPtb8gkjClIQbT7eBRMR866S2BPzfFa5bRyEGS3LIdAwRQM
         Oc5hpatf9cv3uGeyhfDMrJgoZvBw03uDWm04Q=
From: drepper@gmail.com
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 24 Mar 2010 06:49:39 -0700 (PST)
Message-ID: <g766ycf6hwz4din58tUYAxe124vaj_firegpg@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
In-Reply-To: <b2cc26e41003180742k435cbc7eqcf84a65791ee36c@mail.gmail.com>
MIME-Version: 1.0
X-FireGPG-Version: 0.7.10
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="-----firegpg0710eqg766ycgtnlgz2dtsn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
-------firegpg0710eqg766ycgtnlgz2dtsn
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMTgsIDIwMTAgYXQgMDc6NDIsIE9sYWYgdmFuIGRlciBTcGVrIDxvbGFmdmRz
cGVrQGdtYWlsLmNvbT4gd3JvdGU6DQo+ICQgbHMgLWwNCj4gLXJ3eHIteHIteCAxIG9sYWYgb2xh
ZiA1NjAxNjUgMjAxMC0wMy0xOCAxNToyMSB4d2lzDQo+ICQgLi94d2lzDQo+IC1iYXNoOiAuL3h3
aXM6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCg0KWW91ciBzaGVsbCBzaG91bGQgaGFuZGxl
IHRoaXMuICBJJ20gbm90IHN1cmUgd2hldGhlciBpdCdzIGluIHRoZSB1cHN0cmVhbSBiYXNoIChp
dCBzaG91bGQgYmUpIGJ1dCBJIHdyb3RlIGEgbG9uZywgbG9uZyB0aW1lIGFnbyBhIHBhdGNoIHdo
aWNoIHByb2R1Y2VzIGJldHRlciBtZXNzYWdlcy4gIE9uIG15IHN5c3RlbSBJIGdldDoNCg0KJCAu
L3UNCmJhc2g6IC4vdTogL3NvbWUvcGF0aC9kb2VzLW5vdC1leGlzdDogYmFkIEVMRiBpbnRlcnBy
ZXRlcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQ0KDQoNCkl0IGRvZXNuJ3QgcmVhbGx5IG1h
dHRlciB3aGF0IHRoZSBrZXJuZWwgcmV0dXJucy4gIFRoZSBzaGVsbCBzaG91bGQgZG8gaXRzIGpv
YiBhbmQgYXQgbGVhc3QgdGhlIFJIRUwvRmVkb3JhIHZlcnNpb24gZG9lcyBpdCBmb3IgYSBsb25n
IHRpbWUgbm93Lg==
-------firegpg0710eqg766ycgtnlgz2dtsn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Use GnuPG with Firefox : http://getfiregpg.org (Version: 0.7.10)

iEYEARECAAYFAkuqGHYACgkQ2ijCOnn/RHQgHQCgkxpky8SImKdKmQfmW7mc9Oj3
RVgAn26ahM10VKbbZGbkHQIF8hz5h3qH
=0/T5
-----END PGP SIGNATURE-----

-------firegpg0710eqg766ycgtnlgz2dtsn--

