Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384Ab2LHRXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 12:23:14 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:48983 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888Ab2LHRXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 12:23:13 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Dec 2012 12:23:13 EST
Date: Sat, 08 Dec 2012 11:22:57 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Jim Meyering <meyering@redhat.com>, Junio C Hamano <gitster@pobox.com>,
        Miklos Vajna <mszeredi@suse.cz>,
        Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Zac Storer <zac.3.14159@gmail.com>
Subject: Re: Streamlining Developer's Certificate of Origin, Signed-off-by tag
Message-id: <20121208162257.GA27005@odin.tremily.us>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=FL5UXtIhxfXey3p5
Content-disposition: inline
In-reply-to: <20121124232202.GA29962@odin.tremily.us>
 <20121124142515.GA26479@odin.tremily.us>
 <20121121001043.7e1a68df@pyramind.ukuu.org.uk>
OpenPGP: id=39A2F3FA2AB17E5D8764F388FC29BDCDF15F5BE8;
 url=http://tremily.us/pubkey.txt
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 12:10:43AM +0000, Alan Cox wrote:
> > Not just a separate document but project / github / whatever given
> > that other projects are referring to it now, and we stand to gain more
> > in the community by streamlining it more and making it ubiquitous.
>=20
> Cutting and pasting it somewhere works (subject to whatever licensing
> it may have itself), as does having a list and a location for a copy, but
> you still want it in the tree proper.

For easy inclusion (preserving history), I've pulled out commits for
the DCO and related Signed-off-by documentation from Linux and Git
into a new repository [1].

On Sat, Nov 24, 2012 at 09:25:15AM -0500, W. Trevor King wrote:
> So.  What license is the DCO distributed under and who holds
> copyright?

The Git project did some similar copying of the DCO into a new project
[2] and is (like the kernel) distributed under the GPLv2 exact.  To be
consistent with this, I've also released the new signed-off-by
repository under the GPLv2 exact.  If you're using a GPLv2 exact
project, you can merge the `signed-off-by` branch into your project
directly.

Because many projects that are not GPLv2 may still want to use the
DCO/s-o-b approach, I've included an example CONTRIBUTING file (and
CONTRIBUTING.md for GitHub) that are licensed under the very
permissive Creative Commons CC0 1.0 Universal.  Merge the
`contributing` or `contributing-github` branch into your project and
edit as you see fit.  For an example, see the GPLv{2,3} rss2email [3].

Cheers,
Trevor

[1]: https://github.com/wking/signed-off-by
     https://github.com/wking/signed-off-by.git
     git://github.com/wking/signed-off-by.git
[2]: https://github.com/gitster/git/commit/314082512403f7f6969cc6d5ded4a48c=
68a9962e
[3]: https://github.com/wking/rss2email/

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQw2leAAoJEEUbTsx0l5OM9yEP/jGMzQmlIgQ+pLrb9td5FdNR
zPGvOPp0epbGco5dwLrDFkULKBN/eIneMJcQkdaTy8QW/QMQhYIgtgs+mdf07+s+
sdx5Z8bFDfu3kzEttZqfy3GVsNomKM+VdgjmaKQJc7V3bR7YDCJxSxOaxqYRWDJc
DTJUiKj/D9DkaR/fslSlyw92X2n5XjM9lV91FCNFrNVbxiqkamRaOCLVWgJUNtAv
HV/o6JJxrJDdhfhlBgMjFGN4EkuO7JEkn4GYlqDG0Qf+TdLBehOhU+w0gzs9JZxV
0ORnJXEafPvT+TgmnaprYYB1uNKOiPQWAiB4ulitkA57OcP0Lguu4TinteA+8W9/
AaeicI8veZULfv5Ip1tyvP74+vtXlZEWDGOKleK2Xy76JC2nvW3rvx4BdPnWFayr
7nAbYzynG3B3L+eN4BzYOxVn0Tcdy73oqtH77zKPrYrV2m5aTOCQBAF3HKawIg2e
efhP7r0h7JyJsy1UYSoU+Q29yZZI6QEvlVMhY7CM2YV/OvmK2V8SjFs8AOEH5Jl+
oVb3svHmZLhsTiRUSyUhT+oXJ96zna6KqxHiL+tU9ctn8A2o5SizzulXKw8XXDGG
i04dJ5cBdUWSY6bAL48u+TLB9u43mRu0O8+mkxVnjvFDCuSXRlqA0NztjU4NukAl
eNBHB2pcybqBa5J4kbs+
=KZsL
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
