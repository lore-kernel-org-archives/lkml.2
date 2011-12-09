Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1LITsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:48:03 -0500
Received: from che.mayfirst.org ([209.234.253.108]:48242 "EHLO
	che.mayfirst.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1LITsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:48:01 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Dec 2011 14:48:01 EST
Message-ID: <4EE26486.8090904@fifthhorseman.net>
Date: Fri, 09 Dec 2011 14:41:58 -0500
From: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111120 Icedove/8.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dmitry.kasatkin@intel.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [Keyrings] [GIT PULL] Crypto keys and module signing
References: <4EE250E0.6090104@linux.intel.com> <alpine.LRH.2.00.1112100128470.26387@tundra.namei.org> <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org> <28442.1323269262@redhat.com> <2409.1323422253@redhat.com> <4EE2191E.8070107@linux.intel.com> <11634.1323454017@redhat.com> <2762.1323456423@redhat.com>
In-Reply-To: <2762.1323456423@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigBA632495E12069A1A2E96895"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA632495E12069A1A2E96895
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/09/2011 01:47 PM, David Howells wrote:
> Arjan van de Ven <arjan@linux.intel.com> wrote:
>=20
>> ... the temp key can use /dev/urandom.
>> seriously, /dev/urandom for one time, temp keys is not bad
>> (if you care about the difference, you better provide your own real ke=
y)
>=20
> Can you tell gpg which random device to use?

Depending on the version of gpg, supplying either --quick-random or
--debug-quick-random should use a cheaper PRNG.

I think this is an undocumented feature, though.

hth,

	--dkg


--------------enigBA632495E12069A1A2E96895
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQJ8BAEBCgBmBQJO4mSGXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQwRUU1QkU5NzkyODJEODBCOUY3NTQwRjFD
Q0QyRUQ5NEQyMTczOUU5AAoJEMzS7ZTSFznpRdEP/1ZZj6eYDxUxN5et8YtWeUav
cTU3JIXc+Gf+1SzBgeS9wnpzgIhctoPo6CzxDHm847IWyl8dn4CnqxeSgYs7N7jB
vGYVHb0oqKL3jj6So2bEF1yzgVB8aAoWTc8Mdf+gkvadMxLUmhlL/GwL8CnbkkgN
wq96PVPd+COgO2apzDz3t18yQb1+z7tQ4aA7jKuk7p6/kkGj8ITfr75qcks5jhel
q6BY5FrAOh+3RbRdLLUe+mcLtHfi3PTof0wTrQbNJxjaRKop0NPfbYwcZ9O7eYOv
gaZ2U2jvztxeNRqt1qzm7m9fmOiU6kHc94nx167ij3/vRaFF06VUAp/vpsyLfd+q
atykIGepHxdJdK0NjPG3APZY6B8rmSJuHqAk4nOsrL3wiHtjzWESnhMWkmi5ENii
9GZkB5bwYV+5Ua7WRht5+ctA+HDN6x1WNn1D/kJ8kvPSMsgqqsKISsNvuWG24pf5
X8E9OUFh7fFrLnI5f1K55ciVDDLArXrI5YMz6hbOgREjhvzGp3/dTyIl6PEyg9+N
n0ZY51j0zR2SfndAVNVaKd1WsK8sUyaMEgPuqi7WIpgmU/i2B7EraFHEOqRGh8bR
7LLO8pl0ggktc27r2lV6fFeop2Ew12Wh6difgBlplD/CVF+cenhOa2nkALEPja/H
SO8l8Q0b5fDibmjElDQ+
=TPvt
-----END PGP SIGNATURE-----

--------------enigBA632495E12069A1A2E96895--
