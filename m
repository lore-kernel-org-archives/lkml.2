Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2HNPIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:08:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab2HNPIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:08:46 -0400
Message-ID: <502A69FA.8040805@nod.at>
Date: Tue, 14 Aug 2012 17:08:42 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 26 (uml)
References: <502A6759.3090802@nod.at> <15981.1344955883@warthog.procyon.org.uk> <502A613F.1090600@nod.at> <87a9xys53h.fsf@rustcorp.com.au> <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au> <50115FCF.4060708@xenotime.net> <502932A0.3060001@xenotime.net> <15532.1344954413@warthog.procyon.org.uk> <18600.1344956051@warthog.procyon.org.uk> <18933.1344956788@warthog.procyon.org.uk>
In-Reply-To: <18933.1344956788@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB3A42E01BD9E7F7D941E32CC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB3A42E01BD9E7F7D941E32CC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 14.08.2012 17:06, schrieb David Howells:
> Richard Weinberger <richard@nod.at> wrote:
>=20
>> I think arch/x86/um/Kconfig makes more sense.
>=20
> warthog>ls arch/um
> defconfig     Kconfig.common  Kconfig.um     Makefile-os-Linux  scripts=
/
> drivers/      Kconfig.debug   kernel/        Makefile-ppc       sys-ia6=
4/
> include/      Kconfig.net     Makefile       Makefile-skas      sys-ppc=
/
> Kconfig.char  Kconfig.rest    Makefile-ia64  os-Linux/
>=20
> It doesn't exist.  Should I create it?

arch/x86/um, not arch/um.

arch/um/ contains the generic UML stuff.
arch/x86/um/ the x86 specific UML stuff.

Thanks,
//richard



--------------enigB3A42E01BD9E7F7D941E32CC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJQKmn7AAoJEN9758yqZn9eo5MH+wb9aFuvSJBBPi3pkJSR1O5t
gIyjpq9F1UjVTYYB0iSjSFzYAsQ3OpPRVaRvLAm9fqA+W/popqKgVbfiTSOjXjrT
DY+YlpAhzn73PSS7UWp8EY8BB/ax2reYVDcE5gwFWMhDgbbjz9U10RvY8nPwvTOE
XZVPML9yqZm4IFjhTEnbYJMoI4/ELG2RG2pu1oLtPrsJ8r0rB95VndypUVn+M5hN
6gPOxfog6wFkXYZcfYRUEj7ktmESuUgtp1LE0tyzAH9uXFyzCVaNfobOrAMPEkYn
6t1qGBT6zvL/3ZUQn/nDWEPpRGfx//23Q6ir18BJrhWXMRhVaRR6auCWvjfg97Y=
=eCU+
-----END PGP SIGNATURE-----

--------------enigB3A42E01BD9E7F7D941E32CC--
