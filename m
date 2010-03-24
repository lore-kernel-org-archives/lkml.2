Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab0CXWqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:46:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33803 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0CXWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:date:message-id:subject:in-reply-to:mime-version
         :x-firegpg-version:content-type;
        b=t/lvj6s/4Z3ldW1sJtome2eYmB0qd8AVvb3aCt3VenXBOTZ9KQX9Tk8yUUFiS4EXdg
         qzXTSEIaMOgW+N2RQtuzrb34HPLxfE/Cl3FYc5ztdYfdjYo7G4HLlvotGvASvLR7y1Uc
         QjISGPi15/M28ViXBC8TqzKmhRwwUe97ruiAs=
From: drepper@gmail.com
To: Olaf van der Spek <olafvdspek@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 24 Mar 2010 15:45:56 -0700 (PST)
Message-ID: <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
In-Reply-To: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
MIME-Version: 1.0
X-FireGPG-Version: 0.7.10
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="-----firegpg0710eqg76q40k6nrhoss976w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
-------firegpg0710eqg76q40k6nrhoss976w
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgMjQsIDIwMTAgYXQgMTU6MzcsIE9sYWYgdmFuIGRlciBTcGVrIDxvbGFmdmRz
cGVrQGdtYWlsLmNvbT4gd3JvdGU6DQo+IFdoeSBub3Q/DQo+IEl0J3MgYW4gaW1wcm92ZW1lbnQg
SU1PLCBhbHRob3VnaCBpdCBjb3VsZCBiZSBiZXR0ZXIuDQoNCkl0J3MgYmxhdGFudGx5IHdyb25n
LiAgVGhlcmUgaXMgbm8gZHluYW1pYyBsaW5rZXIuICBFTk9FWEVDIG1lYW5zIHRoZSBmaWxlIGV4
aXN0cyBidXQgaXMgbm90IG9mIHRoZSByaWdodCBmb3JtYXQu
-------firegpg0710eqg76q40k6nrhoss976w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Use GnuPG with Firefox : http://getfiregpg.org (Version: 0.7.10)

iEYEARECAAYFAkuqliQACgkQ2ijCOnn/RHT0NACggtX7ckRwc44738RU7iruMq3H
pQoAnjum0Ff00wFAYloth7BLeKdPitwP
=VgtV
-----END PGP SIGNATURE-----

-------firegpg0710eqg76q40k6nrhoss976w--

