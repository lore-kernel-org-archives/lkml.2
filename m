Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1HYXGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:06:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38162 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab1HYXGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:06:45 -0400
Date: Fri, 26 Aug 2011 09:06:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
Message-Id: <20110826090619.7588d424798f53a6f3621eb2@canb.auug.org.au>
In-Reply-To: <4E5693DD.2010307@zytor.com>
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au>
	<4E5690C3.2050706@goop.org>
	<4E5693DD.2010307@zytor.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Aug_2011_09_06_19_+1000_qvGPnk2ddaEkwfol"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Aug_2011_09_06_19_+1000_qvGPnk2ddaEkwfol
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 25 Aug 2011 11:26:37 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 08/25/2011 11:13 AM, Jeremy Fitzhardinge wrote:
> > On 08/24/2011 09:24 PM, Stephen Rothwell wrote:
> >>
> >> Today's linux-next merge of the xen tree got a conflict in
> >> arch/x86/include/asm/spinlock.h between a series of commits from the t=
ip
> >> tree and a smaller series of similar commits from the xen tree.
> >>
> >> I see that Linus is commenting on these patches at the moment, and its
> >> not easy to resolve the conflicts, so I will just use the xen tree from
> >> next-20110824 for today.
> >>
> >=20
> > Thanks Stephen; the xen tree ones are more current, and I want to make
> > sure I didn't screw up any of the cmpxchg/xadd changes in a wider test =
env.
> >=20
>=20
> Stephen: the x86/spinlocks branch in the -tip tree is obsolete and
> should be dropped.

That's a bit tricky as I get a rolled up tip tree.  The best I could do
is revert the commit that merges the x86/spinlocks branch into
auto-latest ...  I'll do that for today (unless something happens to the
tip tree in the next hour).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Aug_2011_09_06_19_+1000_qvGPnk2ddaEkwfol
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVtVrAAoJEDMEi1NhKgbsFOYH/jnZFur5cWbT1SKZp28CUBUj
h2Nov7YNwhcDb5sY2VUd0N+lUuJjdwRwStz5PHjYaSMrnoSXHTn+ZsmMb+0mtsbr
E2ekSsryPJL5q+qPVP9mXfLFMUCATi3j2BJV+ThobEZb2OSe0eg/LIg83CD+E66u
1DekWbCI34KmBhLvzn5fmYFQYlwB+QFEphkJUrorjszK/LVok1RjUex00BG+U2mX
2SXIFQOWQkx13ZUoXAw+mi3MBjC+jLjbReb5iECohRhA+v6bBQis+5VC3YItUpcL
Z/GjVVJ8RuInaqDHNuXSSlLoQAfOiCbQVOMhHSi2ffYQ4eXZXq94Gfuq0E+J+1M=
=j9m6
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Aug_2011_09_06_19_+1000_qvGPnk2ddaEkwfol--
