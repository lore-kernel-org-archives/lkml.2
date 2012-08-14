Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2HNOya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:54:30 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2HNOyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:54:18 -0400
Message-ID: <502A6696.4030200@nod.at>
Date: Tue, 14 Aug 2012 16:54:14 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 26 (uml)
References: <502A613F.1090600@nod.at> <87a9xys53h.fsf@rustcorp.com.au> <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au> <50115FCF.4060708@xenotime.net> <502932A0.3060001@xenotime.net> <15532.1344954413@warthog.procyon.org.uk> <15981.1344955883@warthog.procyon.org.uk>
In-Reply-To: <15981.1344955883@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDC65854493518245CE064E31"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDC65854493518245CE064E31
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 14.08.2012 16:51, schrieb David Howells:
> Richard Weinberger <richard@nod.at> wrote:
>=20
>> Is there no way to get this information from the UML subarch?
>> Which is currently X86_32 or X86_64.
>=20
> Or ppc or ia64?  Or are those defunct?

Those are defunct.
AFAIK viro is working on UML/ppc64.

> I can certainly try pasting the lines from x86/Kconfig to uml/Kconfig.c=
ommon
> to switch the REL/RELA bits, but it would be nice to get this from the =
actual
> arch if possible to reduce redundancy.

The issue happens only on -next, right?
I can have a closer look at the issue tomorrow.

Thanks,
//richard


--------------enigDC65854493518245CE064E31
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJQKmaXAAoJEN9758yqZn9eLOgH/1Er70Qz04+e70Ga1vIAsYvI
cwCi+G75LBUC6T3W1N4AF7QW3WzEiy1+4+AJd0SJIntp0EDcpTqJ0XM9lEyD7jRp
S1qc4+Ls6xMEUcDCnOiiLll2u/7TJRcTrUmxCWYI+AvN9JAvNsMWWHgweDxUA917
/MbjnRl6TtAgD0mZdIUFbSDKQNPLWv6ItRmm5EX5Ddl0RjMOT8hEGdOIAPcNNrTJ
PFp8cRCt3rt7LHdwnec1E5iymAP/aPPiAFCNgpAPs1xz190f4EdCjvwe6lrtGSmX
PnyhU7eimWghKCaX7mdhd4iL7/w/pnUc7LwYfZ4nBSgwgASuhej5rutFhuTDSnU=
=8dnn
-----END PGP SIGNATURE-----

--------------enigDC65854493518245CE064E31--
