Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1IAGIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:08:49 -0400
Received: from mail.southpole.se ([193.12.106.18]:48009 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab1IAGIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:08:46 -0400
Subject: Re: RFD: x32 ABI system call numbers
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Tobias Klauser <tklauser@distanz.ch>
Date: Thu, 01 Sep 2011 08:08:03 +0200
In-Reply-To: <201108311814.54906.arnd@arndb.de>
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de>
	 <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-CrmFQ2262uBINVU0x203"
X-Mailer: Evolution 3.1.5- 
Message-ID: <1314857296.11447.17.camel@satguru>
Mime-Version: 1.0
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-CrmFQ2262uBINVU0x203
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-08-31 at 18:14 +0200, Arnd Bergmann wrote:
> On Tuesday 30 August 2011, H. Peter Anvin wrote:
> > On 08/30/2011 05:09 AM, Arnd Bergmann wrote:
> > >=20
> > > I'm wondering about the time_t changes: given that we are still addin=
g
> > > new 32 bit architectures, should we change the asm-generic API as wel=
l
> > > to use 64 bit time_t by default (with fallbacks for the existing ones=
)?
> > >=20
> > > If you are adding support for these in x32 already, we could use the
> > > same code for regular 32 bit architectures.
> > >=20
> >=20
> > It seems absolutely boggling insane that we're introducing new
> > architectures with no legacy whatsoever and use 32-bit time_t on those.
>=20
> I've added a few people to Cc who are in various stages of the
> process to finalize their upstream kernel ports. It's clearly
> the right decision to have time_t 64-bit eventually, the question
> is how much work is everyone willing to spend in the short run,
> and who is going to test it. In particular, openrisc has just
> been merged, so we should not be changing it any more unless
> there is a serious problem, but if there is not much legacy user
> space with the current ABI yet, it may still be worth switching
> over.

As far as OpenRISC is concerned, this change can still be made now.  I
know who the users of this platform are and, considering the rest of the
libc churn that comes with dropping the legacy syscalls, I can guarantee
that nobody's going to complain.  OpenRISC may be merged but 3.1's not
released yet so there's still a bit of wiggle room to get this done.

/Jonas

--=-CrmFQ2262uBINVU0x203
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk5fIUMACgkQ70gcjN2673OGzQCfffacfIdfJ85u7pjDKy+M6qDZ
Qd8Ani3I+PnBAV6gpAc7VJpHv5HpBXCa
=zomY
-----END PGP SIGNATURE-----

--=-CrmFQ2262uBINVU0x203--

