Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2EMN7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:59:07 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63820 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2EMN7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:59:05 -0400
Message-ID: <4FAFBE24.7000307@gmail.com>
Date: Sun, 13 May 2012 15:59:00 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] Add Apple NLS
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig9A4897573F0E2254A940E6D8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9A4897573F0E2254A940E6D8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

HFS has support for NLS. However the relevant NLS tables are missing.
Here are they automatically transformed from the tables at unicode.org.
Codepages requiring special handling like CJK, RTL or Brahmic ones aren't=

included in this patch.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>

Patch itself is at http://download-mirror.savannah.gnu.org/releases/grub/=
phcoder/nls.diff due to its size (309K)



--------------enig9A4897573F0E2254A940E6D8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+vviQACgkQNak7dOguQgnbuAD9EQnbzmf8g3jbj08fQAjxbVvm
XK6QCd/bjp5d9oc6B6UA/AkQQ2q0jvxIJMhwxOGnFyvEb7xTtV8DeO9MMRmVffcw
=L+Rx
-----END PGP SIGNATURE-----

--------------enig9A4897573F0E2254A940E6D8--
