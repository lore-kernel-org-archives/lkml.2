Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1BRDy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:54:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57871 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab1BRDyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:54:23 -0500
Date: Fri, 18 Feb 2011 14:54:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20110218145411.24bf7ad7.sfr@canb.auug.org.au>
In-Reply-To: <20110218094754.0436a60a.sfr@canb.auug.org.au>
References: <20110131154259.dca1f7e6.sfr@canb.auug.org.au>
	<20110217144743.2db26b27.sfr@canb.auug.org.au>
	<4D5D201A.8090304@suse.cz>
	<20110217150200.GA32177@sepie.suse.cz>
	<20110218094754.0436a60a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Feb_2011_14_54_11_+1100_lcTy8DMOXhEwQz=6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Feb_2011_14_54_11_+1100_lcTy8DMOXhEwQz=6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Fri, 18 Feb 2011 09:47:54 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 17 Feb 2011 16:02:00 +0100 Michal Marek <mmarek@suse.cz> wrote:
> >
> > > _Maybe_ we could work around it by letting fixdep remove the actual
> > > source file from the list of dependencies in the .cmd file. The
> > > dependency on the .c / .S / whatever file is given by the Makefiles, =
the
> > > .cmd file is only needed for additional dependencies on headers. Let's
> > > see what else breaks then ;).
> >=20
> > It seems to work for me. Can you try the patch below? It needs to be
> > applied before merging 9599ec0 to have any effect.
>=20
> Thanks, I will apply this as a fix on top of Linus' tree before I merge
> anything else.  It looks simple enough that Linus may take it as a fix
> right now.   Better to convince ourselves first, though, right?

That patch fixed the problem for me and has caused no obvious problems.

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__18_Feb_2011_14_54_11_+1100_lcTy8DMOXhEwQz=6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNXe1jAAoJEDMEi1NhKgbsfkYH+wRmp2/MD0HNeOqXddVSF/yw
zR6hyaovNE/R1kOv2CtaBKVfNRMP15uI816Z8pJKvBXVRXF/bSd/LvsbppjUf3Aq
65NDhX4OWxiIFWesHcvBjwAumIO58ZRle2qvjT33y8u7SNrxKKQpWDJkoQ9AGR22
pJdbtce9MpBEaOugr7sRlJm84zqICsRy7UJLtbUOeIKdLc6Mf4jvz/fK71ZDyUEg
5rIEaQ7GNwQloTs4RkxKhLax8/B0dCGMcZmbC6cK+RPMuSnEiwYJLxSAcaYgeNj/
+0QJK/zkc2x98t8oaWXMsfPxRWqYI9pWy/mnrX//zBlCJWKR7wTG3YvWP3xjElY=
=Ky1R
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Feb_2011_14_54_11_+1100_lcTy8DMOXhEwQz=6--
