Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0HJPIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:08:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56647 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab0HJPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HNVSXjrbjUg8yXZNbAOE1wb6FxcffvAC/WoVI56R9g0S0X6wzGCOTzRyYD6g7Ju+5u
         JoHqHv8XBhP+uim5qtLQoDHl8PJky4pcqJiDVbxacKGtPLDY+cYbYmdWhiiV5x9NbeG6
         oRwBeeig6b8bJzxgDgy824tlCJSkixMnO02X0=
Date: Tue, 10 Aug 2010 18:13:12 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
        Piotr Hosowicz <piotr@hosowicz.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-acpi@vger.kernel.org
Subject: Re: BUG: scheduling while atomic: swapper/0/0x10000002
Message-ID: <20100810151312.GA5466@swordfish.minsk.epam.com>
References: <20100810140748.GA29878@fancy-poultry.org>
 <20100810142951.GA7156@arch.tripp.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20100810142951.GA7156@arch.tripp.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks.

	Sergey

On (08/10/10 16:29), Markus Trippelsdorf wrote:
> On Tue, Aug 10, 2010 at 04:07:48PM +0200, Heinz Diehl wrote:
> > +1
> >=20
> > [....]
> > ACPI: Core revision 20100702
> > BUG: scheduling while atomic: swapper/0/0x10000002
> > Modules linked in:
> > Pid: 0, comm: swapper Not tainted 2.6.35-git8 #1
> > Call Trace:
> > [<ffffffff81441be8>] ? schedule+0x518/0x9a0
> > [<ffffffff812e4262>] ? acpi_os_release_object+0x9/0xd
> > [<ffffffff8103dcfd>] ? __cond_resched+0x1d/0x30
> > [<ffffffff814421dd>] ? _cond_resched+0x2d/0x40
> > [<ffffffff81300ca0>] ? acpi_ps_complete_op+0x24c/0x260
> > [<ffffffff813014c9>] ? acpi_ps_parse_loop+0x815/0x970
> > [<ffffffff813005d8>] ? acpi_ps_parse_aml+0x8f/0x2aa
> > [<ffffffff812fee85>] ? acpi_ns_one_complete_parse+0xfd/0x118
> > [<ffffffff812feeba>] ? acpi_ns_parse_table+0x1a/0x34
> > [<ffffffff812fc685>] ? acpi_ns_load_table+0x3d/0x7c
> > [<ffffffff81303321>] ? acpi_load_tables+0x9b/0x156
> > [<ffffffff81798d87>] ? acpi_early_init+0x6c/0xf7
> > [<ffffffff81771cf5>] ? start_kernel+0x368/0x436
> > [<ffffffff81771382>] ? x86_64_start_kernel+0xe1/0xf2
>=20
> This bug already has two patches available to fix it:
> =20
> http://lkml.org/lkml/2010/8/6/672
> https://patchwork.kernel.org/patch/113092/
>=20
> --=20
> =BBA man who doesn't know he is in prison can never escape.=AB
> William S. Burroughs
>=20

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxhbIgACgkQfKHnntdSXjRzwQP/TJ7TG1DAZwIJnT1yD7IezpRB
smQliWeOIR/B3HVMspQuHGuJ+G32YL2WAqC0lt6nRpWDAXTOXcWhkZ/MD4qF95qH
bY2uV/8vt3WmRKaY7ApPFUiDEmGZ8DZRCfqO8iYJZOr1YpQYndbwgZLBYR5fSujc
FApVL4GcuqI2IcgDl4c=
=dNuI
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
