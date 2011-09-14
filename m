Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1INAcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 20:32:46 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38330 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1INAco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 20:32:44 -0400
Date: Wed, 14 Sep 2011 10:32:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
Message-Id: <20110914103234.4f2f6a2dd65734de6622e79f@canb.auug.org.au>
In-Reply-To: <4E6FC2D3.2060408@goop.org>
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au>
	<4E5690C3.2050706@goop.org>
	<4E5693DD.2010307@zytor.com>
	<20110826090619.7588d424798f53a6f3621eb2@canb.auug.org.au>
	<4E56D6E1.6030405@zytor.com>
	<20110826125441.709aa423cdf072ce085fb91c@canb.auug.org.au>
	<20110913211154.fe53ca8c1d608def77a69022@canb.auug.org.au>
	<alpine.LFD.2.02.1109131706410.2723@ionos>
	<4E6FC2D3.2060408@goop.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Sep_2011_10_32_34_+1000_XZM3NiBv=JSQE3KM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Sep_2011_10_32_34_+1000_XZM3NiBv=JSQE3KM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

On Tue, 13 Sep 2011 13:53:39 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wr=
ote:
>
> On 09/13/2011 08:07 AM, Thomas Gleixner wrote:
> > On Tue, 13 Sep 2011, Stephen Rothwell wrote:
> >>
> >> On Fri, 26 Aug 2011 12:54:41 +1000 Stephen Rothwell <sfr@canb.auug.org=
.au> wrote:
> >>> On Thu, 25 Aug 2011 16:12:33 -0700 "H. Peter Anvin" <hpa@zytor.com> w=
rote:
> >>>> On 08/25/2011 04:06 PM, Stephen Rothwell wrote:
> >>>>>> Stephen: the x86/spinlocks branch in the -tip tree is obsolete and
> >>>>>> should be dropped.
> >>>>> That's a bit tricky as I get a rolled up tip tree.  The best I coul=
d do
> >>>>> is revert the commit that merges the x86/spinlocks branch into
> >>>>> auto-latest ...  I'll do that for today (unless something happens t=
o the
> >>>>> tip tree in the next hour).
> >>>>>
> >>>> OK, let me bother Ingo about it.
> >>> For today, I have done "git revert -m 1 6f8fa39c81f1" after merging t=
he
> >>> tip tree.
> >> I am still doing this in each linux-next, and it doesn't appear to have
> >> been fixed up the the tree on tesla.tglx.de, yet, I think.
> > We'll take it out.=20
>=20
> Actually, the tip x86/spinlocks was the most up-to-date version of those
> patches (since hpa had rebased them to a more recent version of mainline).
>=20
> But never mind.  Stephen, could you use
>=20
>     git://github.com/jsgf/linux-xen.git upstream/xen
>=20
> for linux-next instead of the kernel.org xen.git, and I've re-added the
> up-to-date spinlock changes there.

OK, I have switched to this from today.

My understanding is this:  I do *not* need to revert the spinlock changes
from tip anymore, correct?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Sep_2011_10_32_34_+1000_XZM3NiBv=JSQE3KM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOb/YiAAoJEDMEi1NhKgbs6zUH/AxDWuN4AXeNYpsajyioPglF
+1NSWctPiCt15Kub2zeiBcKyYIhFO8KDlyqT3TAMGDS+lK9XsT490OXfdnMLVAAN
A34AZ1xTtkOqrsv9LdQpqnyr3jcq42CUkpMtdacRRmP7qUnaqBGc1PI4iwsAFhbm
aF47Ud77I7fmXJDyi73zka6tlP7HxH/G78JUoBo/NKBb4Lyuv40UL3+CVBdxPZxu
KaCG3w1Yvs+psAoW0ts29wCt0QqchIaaQfXXeVH+ARxvSwqOJezGs9Nlp9gxFhRa
HGtU3U6RsW5JBEgWxu7Tj4OdjMjddNc9kycjAdgND129Wn/Pjaq84G/z/qYBmGw=
=OFgd
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Sep_2011_10_32_34_+1000_XZM3NiBv=JSQE3KM--
