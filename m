Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1KCVh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:37:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47697 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1KCVh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:37:27 -0400
Message-ID: <4EB30994.9050309@nod.at>
Date: Thu, 03 Nov 2011 22:37:24 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
Subject: Re: [GIT PULL] UML changes for 3.2
References: <4EB14F51.1050004@nod.at>  <1320348750.14409.249.camel@x61.thuisdomein>  <1320352899.14409.260.camel@x61.thuisdomein>  <1320354072.14409.265.camel@x61.thuisdomein>  <4EB3045A.6050501@nod.at> <1320355503.14409.269.camel@x61.thuisdomein>
In-Reply-To: <1320355503.14409.269.camel@x61.thuisdomein>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF84656C889F5D3E325602174"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF84656C889F5D3E325602174
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 03.11.2011 22:25, schrieb Paul Bolle:
> On Thu, 2011-11-03 at 22:15 +0100, Richard Weinberger wrote:
>> I'm confused. What is "make update-po-config" supposed to do?
>> It seems to iterate over all archs and reads their Kconfig, right?
>=20
> It generates an enormous file (linux.pot) with all (help?) strings in
> all Kconfig files that people could translate from English to other
> languages. Seems like quite an effort to do that. I wonder if it has
> ever been done.
>=20

Okay, now it makes sense.

Your patch looks fine with one exception, setting SUBARCH to the empty
string could be problematic in the future.
Currently it's only used in arch/x86/um/Kconfig for 'mainmenu "User Mode
Linux/$SUBARCH $KERNELVERSION Kernel Configuration"'
But this may change...

Thanks,
//richard


--------------enigF84656C889F5D3E325602174
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJOswmUAAoJEN9758yqZn9e4CAH/R8SjG+tCY23Muef+YTE5uxb
otgo4uY4I4+IjEkMEHRHzXlpisfHDk+z5KiWAk+k6BnPsLGY1VwH5o6u+UUWxmWh
1HrdEgiMs2rVnKym+iZwJgrFKYx+2p9Y8au9lbYcql3YOt8RFgpzDkw7uGJxCdkS
AEe15tQeVdHyHqKbT85H2eLujQ+ES64J4LCyRP3fGHj8MsusRiyXy3WfiTwQ/RQS
gOuqJB9HfasiQHdlIBfoGiFzsqf0VRa9JZxvwAuLWdnTbXrDiDlmCVuk9lwGeL9h
oGAxWyChETvd912ZOUbAS53NgB/KNO32vNSMZ5Wd9rZ/Z7MPA2rZF5v1YOI+CT8=
=ary6
-----END PGP SIGNATURE-----

--------------enigF84656C889F5D3E325602174--
