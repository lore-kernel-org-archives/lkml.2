Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625Ab2FASOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:14:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34870 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab2FASOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:14:19 -0400
Message-ID: <4FC9066E.8060005@gmail.com>
Date: Fri, 01 Jun 2012 20:14:06 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Emmanuel Benisty <benisty.e@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 71ca97da9d overrides user's kernel config
References: <CA+i8gKK5VJU_0YbBkeav6wTP+5YGp-rd52dTNqyoprz_YZrepA@mail.gmail.com> <4FC8E00E.60600@gmail.com> <CA+55aFyK_m8aO57gC4Q1PJXmY3e1-uRXQ3E6PRgdBVixJSa2gQ@mail.gmail.com>
In-Reply-To: <CA+55aFyK_m8aO57gC4Q1PJXmY3e1-uRXQ3E6PRgdBVixJSa2gQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigFEBDD18A812E68212FEC42FE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFEBDD18A812E68212FEC42FE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> Yes, but I wonder if they should *also* be renamed, actually.
>=20
> Those names are disgusting and unreadable, because the "MAC" part
> mixes with the actual name of the codepage. I really have a hard time
> reading something like MACROMANIAN, because to me it looks like it
> starts with "MACRO". It's just a bad name.
>=20

I agree. It was something I've seen used as charset name but quick
websearch shows better alternatives like "Mac Romanian", "Mac OS
Romanian". Should I rename the charsets themselves as well?

> Also, the CODEPAGE part adds questionable value. I wonder if we should
> (a) remove the CODEPAGE part, (b) add an underscore between "MAC" and
> the name, and for the microsoft numeric codepages, do the same just to
> be consistent. IOW, use config names like NLS_DOS_1250 and
> NLS_MAC_ROMANIAN?

I'm ok with changing my newly-added charsets but I think that there is
no reason to rename already existing ones. It would just add a bunch of
new questions at reconfigure not corresponding to any real
functionality. Also, I believe, that the whole reason of NLS codepage
tables to exist is the ability to read old volumes and marginally the
ability to interchange data with old OS in a best available way. The
least it used for any purpose outside speaking with old OS or touching
old volumes, the better.
I'll prepare 2 patches: cleanup, config rename and codepage rename.
--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigFEBDD18A812E68212FEC42FE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/JBm4ACgkQNak7dOguQgk4dAD/Xm9EpJXIdwUjw5bCyYGSfhle
Fe2UYjpmDufqKr+TwygA/2e8Hwug5pjXlJXGR32Tv2h/2xHiNvH9gEJSeb0D5CYz
=vswi
-----END PGP SIGNATURE-----

--------------enigFEBDD18A812E68212FEC42FE--
