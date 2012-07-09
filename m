Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2GIPqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:46:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52658 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab2GIPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:46:36 -0400
Date: Mon, 9 Jul 2012 16:46:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, grant.likely@secretlab.ca
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709154633.GH3934@opensource.wolfsonmicro.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120707032907.GA15120@srcf.ucam.org>
 <20120709123253.GA31383@sirena.org.uk>
 <20120709130629.GA29130@srcf.ucam.org>
 <20120709132420.GF3934@opensource.wolfsonmicro.com>
 <20120709140222.GA30838@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G3juXO9GfR42w+sw"
Content-Disposition: inline
In-Reply-To: <20120709140222.GA30838@srcf.ucam.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G3juXO9GfR42w+sw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 03:02:22PM +0100, Matthew Garrett wrote:
> On Mon, Jul 09, 2012 at 02:56:26PM +0100, Mark Brown wrote:

> > Where is this discussion?

> My part of it has pretty much been in-person discussion with Grant=20
> Likely, but there was some on ksummit-discuss last month.

Oh, I saw some of the ksummit-discuss traffic but didn't register it as
a serious proposal to do something.

> > Right, but there's lots of bolierplate code with this stuff anyway and
> > it's not fundamentally hard.  Last time I looked at ACPI it had a rather
> > different model for how all this stuff would work than DT did which
> > isn't terribly helpful here.

> ACPI 5 lets devices expose their GPIO resources directly, so in some=20
> cases a driver will just be able to request that and handle things as it=
=20

Assuming the naming standard is the same and so on...  my understanding
was that it's difficult to get any sort of standardisation on ACPI
bindings for device drivers.

> would in ftd. But the more traditional ACPI method is to use ACPI=20
> notifications, and those happen in process context. It seems unlikely=20
> that everyone's going to get it right unless there's existing in-kernel=
=20
> infrastructure for handling this.

Oh dear, that sounds awesome.

--G3juXO9GfR42w+sw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+vzTAAoJEBus8iNuMP3d/mEP/RO8tyTJnWu5bcEHz8WdDkYp
mQSTzuemp3NQPDLmASk4yuk2/DLJTMB2YliPfwa78aIrnikFtDs79Jb1Sw729fiS
pSr+tPTzI4MI0mxnEazM7qNx2qdiit7J4IBaUjuDcXdR3do59nb8UMvqz2AfBMdT
oVqW/rOW5yv2Ma5+NHmwN44IQftg6Khuk7o2D7BPun7iNbR3tdZnn/yMrlwjB7lZ
mfL5VfewCqwQpsyZqtD13tJ6dO2f5BSN1ljKc6qO0yuljXjp/YrwCUACK2/YQJNW
podjxDJ5rYiNi2Fduz6ny30ihPDfrN2ucDR71xJQTSbY36M3rTziAu+VnptcbrDv
DX4jY1DxAbfviddlXdV+EGfenZN2bNwpJ+eTRABvkIhgicUXyTuBBCvukxON53Ju
osiZTnKK7LLfXjNJ7a/S96mM5mSu5bBJrzFk7dM+xqiztBjYQv5jrYIVcVrLze9A
A29ipu/7vHoXHhpo2oOUfBh26XCBxtSgLxfTIHqFUrIoN2fcMaQPhbdCz2rLubP9
FS1rm2LqxNKTCI/wITkEH5CpNfnhLByhdbt6/d4oTL7DDC/XBNQm9EXeFCpQYxe3
5WE0/QaNUBjJ4Uq0zJ119O86IFSzOwihOVyZZ4NyYPsUZuG/1p6/3nsUkP44ahqq
gkjZOoTVANO4X8B1kZ6A
=G5Dn
-----END PGP SIGNATURE-----

--G3juXO9GfR42w+sw--
