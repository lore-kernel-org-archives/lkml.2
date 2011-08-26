Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1HZCyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 22:54:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40411 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1HZCyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 22:54:51 -0400
Date: Fri, 26 Aug 2011 12:54:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
Message-Id: <20110826125441.709aa423cdf072ce085fb91c@canb.auug.org.au>
In-Reply-To: <4E56D6E1.6030405@zytor.com>
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au>
	<4E5690C3.2050706@goop.org>
	<4E5693DD.2010307@zytor.com>
	<20110826090619.7588d424798f53a6f3621eb2@canb.auug.org.au>
	<4E56D6E1.6030405@zytor.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Aug_2011_12_54_41_+1000_gxlZbU7HGmsiOdR7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Aug_2011_12_54_41_+1000_gxlZbU7HGmsiOdR7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Aug 2011 16:12:33 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 08/25/2011 04:06 PM, Stephen Rothwell wrote:
> >>
> >> Stephen: the x86/spinlocks branch in the -tip tree is obsolete and
> >> should be dropped.
> >=20
> > That's a bit tricky as I get a rolled up tip tree.  The best I could do
> > is revert the commit that merges the x86/spinlocks branch into
> > auto-latest ...  I'll do that for today (unless something happens to the
> > tip tree in the next hour).
> >=20
>=20
> OK, let me bother Ingo about it.

For today, I have done "git revert -m 1 6f8fa39c81f1" after merging the
tip tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Aug_2011_12_54_41_+1000_gxlZbU7HGmsiOdR7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVwrxAAoJEDMEi1NhKgbs6AkH/i5uzk7RBPrZIoXF27pejwyV
TcE7wtD9aHph9o9F7CCxAz/w6EIU8yt7UovP45yfAmvw9Cgm6efh+dJas0ald9nk
6upkzZ1ewtzI8y0wLVVzowIlmUQnPrtDdcSym5cUnBB2SiMEu2ukvmz/lcJbpBPs
cQvx9zoe1JeLVAiwYrX3/eCTHvfjkgBAxQ43G8Jf7fRLUe4S6zBLw1sO0/M1Qw3A
j0SERu8kwGhLBagn9Z1ZqJAKHjzz6bQKrX9TfAir81H7vmVmtSoxdEw/I9ff+90K
HE1RGLDMZwfG4sPxBVEEwa2r4Wh/hTGnljdOAsoyLZbQGrnDS177MVczUt3Sc5I=
=66HE
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Aug_2011_12_54_41_+1000_gxlZbU7HGmsiOdR7--
