Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2ADIG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:06:28 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:33336 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2ADIG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:06:26 -0500
Date: Wed, 4 Jan 2012 19:06:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: build warnings after merge of the final tree
Message-Id: <20120104190613.2e76daaa000ccf61121fdcc1@canb.auug.org.au>
In-Reply-To: <20111222163304.26be6d0f5e514fefb078c0a6@canb.auug.org.au>
References: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au>
	<1323880322.23971.33.camel@gandalf.stny.rr.com>
	<4EE8D305.8020407@zytor.com>
	<20111222163304.26be6d0f5e514fefb078c0a6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Jan_2012_19_06_13_+1100_=XMCdw1VstOWS2uq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Jan_2012_19_06_13_+1100_=XMCdw1VstOWS2uq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Thu, 22 Dec 2011 16:33:04 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 14 Dec 2011 08:47:01 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
> >
> > On 12/14/2011 08:32 AM, Steven Rostedt wrote:
> > > On Wed, 2011-12-14 at 18:15 +1100, Stephen Rothwell wrote:
> > >=20
> > >> Maybe caused by commit d5e553d6e0a4 ("trace: Include <asm/asm-offset=
s.h>
> > >> in trace_syscalls.c") from the tip tree.  These warnings may have be=
en
> > >> here for a while as it is hard to catch the new ones among the flood.
> > >>
> > >=20
> > > hpa,
> > >=20
> > > Was this change only needed for x86? If so, could you put that into
> > > asm/ftrace.h instead?
> >=20
> > Yes (on both accounts).  It was part of the syscall changes; I'll move
> > the include.
>=20
> Ping?

Can we please have this fixed ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__4_Jan_2012_19_06_13_+1100_=XMCdw1VstOWS2uq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBAh1AAoJEECxmPOUX5FEeBsP/3LXm2GIoBX9+SjaarruwAH1
L/VRiNp8e+OfBb2U69bbL+si9KQAp+mp3gikaaVQnCdHrxZH9mSQqN/2BE8TOz2w
FGb5zPUp/kqyDqIJ0/ixNOU9SK7o89KvTGKaFMK6FpoQv1Q/bIiyCr0MWUnrpwuP
jAHx7TUODds8d5oJHEt2y6pBjxUL3lKEB38sVNUrpPmIZYMkzERprkoCn0bq+aqV
mg44TjJoBbRbxXvt2kSrKN0hQhCvgiXZtELo2MUtxdm7KEmayWhgcUnCE39vsEmR
OclwJ/ds9JvvoqUIxQMm/YzTAl0zpLJCc4hXQJB3gLcboGzo5wHkc73+7KK+Dl7q
Oygw1iBk9NUCH/dsp6tUz+aBKANya/rOO6bnOb7xqd6cu+rAOqg+RG1AtD2ozz8c
P3sIUnNI/SCZCEGWPtW2zJHr7KUyk4ILKoPaQFcfpNOKviLPpwH0ApSlfW7wRzGu
M2FJFS+Fnn1MpoFwxWXVIEqwnAdiNfGIqyln8/uLyOR/5toONlatJE4pH42svF8J
RvB9557FMWgIGDgeI1l8uLQp6G9VMGgksiiXI7q4IXINmvqoniijcO1uE4MyPhrK
2VvigityJXJzi6Ppmsh4nSfPghadu2k+aQQ1dVDnY/bOFULQKBSwCZpzukTeHPwM
jIUUD/ljv2vp2dTK9gNN
=P/Hx
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Jan_2012_19_06_13_+1100_=XMCdw1VstOWS2uq--
