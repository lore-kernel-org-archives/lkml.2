Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab1FWAfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:35:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54389 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992Ab1FWAfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:35:14 -0400
Date: Thu, 23 Jun 2011 10:35:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging related)
Message-Id: <20110623103503.cd9e7e70.sfr@canb.auug.org.au>
In-Reply-To: <20110616191448.GA10255@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
	<20110609184127.GA2760@kroah.com>
	<20110609192243.GA3980@kroah.com>
	<20110610160548.529797c7.sfr@canb.auug.org.au>
	<20110610160938.cd01c408.sfr@canb.auug.org.au>
	<20110610223423.GB15868@kroah.com>
	<20110615142155.bd538b73.sfr@canb.auug.org.au>
	<20110616191448.GA10255@kroah.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jun_2011_10_35_03_+1000_=5_xb5u0CzgSqBxL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jun_2011_10_35_03_+1000_=5_xb5u0CzgSqBxL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 16 Jun 2011 12:14:48 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Wed, Jun 15, 2011 at 02:21:55PM +1000, Stephen Rothwell wrote:
> >=20
> > On Fri, 10 Jun 2011 15:34:23 -0700 Greg KH <greg@kroah.com> wrote:
> > >
> > > On Fri, Jun 10, 2011 at 04:09:38PM +1000, Stephen Rothwell wrote:
> > > >=20
> > > > On Fri, 10 Jun 2011 16:05:48 +1000 Stephen Rothwell <sfr@canb.auug.=
org.au> wrote:
> > > > >
> > > > > No, I still get these:
> > > > >=20
> > > > > In file included from drivers/staging/comedi/drivers/addi_apci_03=
5.c:7:0:
> > > > > drivers/staging/comedi/drivers/addi-data/addi_common.c: In functi=
on 'i_ADDI_Attach':
> > > > > drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: er=
ror: implicit declaration of function 'virt_to_bus'
> > > > >=20
> > > > > virt_to_bus is only defined for 32 bit powerpc (not 64 bit) (and =
maybe
> > > > > not at all on some architectures e.g. sparc).
> > > > >=20
> > > > > From Documentation/DMA-API-HOWTO.txt:
> > > > > "All drivers should be using these interfaces with no exceptions.=
  It
> > > > > is planned to completely remove virt_to_bus() and bus_to_virt() as
> > > > > they are entirely deprecated.  Some ports already do not provide =
these
> > > > > as it is impossible to correctly support them."
> > > >=20
> > > > Drivers that use virt_to_bus should Kconfig depend on VIRT_TO_BUS.
> > >=20
> > > Ah, I missed that, sorry.  I'll go make that change as well.
> >=20
> > Ping?
>=20
> Sorry, been swamped with other work, I'll get to this soon...

ping?

> With a very relative value of soon.

Yeah, I understand busy ... but this is a simple patch, rigth?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Jun_2011_10_35_03_+1000_=5_xb5u0CzgSqBxL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOAoo3AAoJEDMEi1NhKgbsZp4H/RgMLXOM+unmWA/M2q7sjWHr
wFO0GGHcbXadgOV2TwehmnPJaoDNJI4Hn0SfZznGoewgWHcl+weBEq4gXoNhAbdv
puqZJd3IVFaSVHn/u3nlVn7jTa25k0v1lAPNs8FiAOFYbDCYCy7TXkMwbR3LCxHG
pi0tjia59wlvojJfrOEZ1rBuc0gcW1EfYQfTA6ZuHgcRflRER+aUJoCLEDgZNZ5Y
HKg9N1ALjODvkMXP0/MeykViG13YytftiXvMUbplCCUcB6AVeFmJWLqEHkLdZxsP
VkSWWPlhCLwhnd0Rsw3Yv8uOPVOxgtDoq1mJZZDe76Q5f/ZBx703QFKMA55hoYM=
=+uPo
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jun_2011_10_35_03_+1000_=5_xb5u0CzgSqBxL--
