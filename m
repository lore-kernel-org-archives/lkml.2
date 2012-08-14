Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab2HNO5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:57:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab2HNO5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:57:32 -0400
Message-ID: <502A6759.3090802@nod.at>
Date: Tue, 14 Aug 2012 16:57:29 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 26 (uml)
References: <15981.1344955883@warthog.procyon.org.uk> <502A613F.1090600@nod.at> <87a9xys53h.fsf@rustcorp.com.au> <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au> <50115FCF.4060708@xenotime.net> <502932A0.3060001@xenotime.net> <15532.1344954413@warthog.procyon.org.uk> <18600.1344956051@warthog.procyon.org.uk>
In-Reply-To: <18600.1344956051@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8E501A7871E5A94D4A2E91DD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8E501A7871E5A94D4A2E91DD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 14.08.2012 16:54, schrieb David Howells:
> David Howells <dhowells@redhat.com> wrote:
>=20
>> I can certainly try pasting the lines from x86/Kconfig to uml/Kconfig.=
common
>> to switch the REL/RELA bits, but it would be nice to get this from the=
 actual
>> arch if possible to reduce redundancy.
>=20
> The attached patch works.
>=20
> David
> ---
> diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
> index cb837c2..0463e48 100644
> --- a/arch/um/Kconfig.common
> +++ b/arch/um/Kconfig.common
> @@ -11,6 +11,8 @@ config UML
>  	select GENERIC_CPU_DEVICES
>  	select GENERIC_IO
>  	select GENERIC_CLOCKEVENTS
> +	select MODULES_USE_ELF_REL if X86_32
> +	select MODULES_USE_ELF_RELA if X86_64

I think arch/x86/um/Kconfig makes more sense.

Thanks,
//richard


--------------enig8E501A7871E5A94D4A2E91DD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJQKmdZAAoJEN9758yqZn9euisH/14FmxsgQ+gSJtgG2YWNqJpt
FfbLvJOJnMcwMCkt3KAT0HA/DxC0WrIFYxbyItAzkZrFg/0CU+O9g1Qe4YKj05mc
HZP+qqjaFktDK8gxgNkL6PgrXJLtb7LdnT8NK/3sNco0rOYhvRFS13yT3RSKwV3T
Ifr+/N7DTCudWHRrxlFf5KlTI/zh8MvFBj9hyJXTWYJaqgwM4bxZTNzB9hydWIac
rW4ny72wU1syhyGXeJaDM6a0M4YdslEZ/Hu0YzsvNXE2v63AwktqBvZPZJrrQa17
fZOjFlVZ0aIf7M5uwyOr9SOJ+SvBqhzD/JPOUWmGfkr0/I556SD7x7OJ6v7+pz0=
=PDUD
-----END PGP SIGNATURE-----

--------------enig8E501A7871E5A94D4A2E91DD--
