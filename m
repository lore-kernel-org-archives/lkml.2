Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab2EVBKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:10:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41238 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2EVBKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:10:23 -0400
Date: Tue, 22 May 2012 11:10:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, anton@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jkenisto@us.ibm.com, andi@firstfloor.org, hch@infradead.org,
        ananth@in.ibm.com, vda.linux@googlemail.com,
        masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        srikar@linux.vnet.ibm.com, roland@hack.frob.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/uprobes] uprobes, mm, x86: Add the ability to install
 and remove uprobes breakpoints
Message-Id: <20120522111007.26f8870307b705f3e09ab36c@canb.auug.org.au>
In-Reply-To: <CA+55aFw5ccuvvtyf6iuuw-Finr79ZkPxgCxL5jNvdnX5oMYkgg@mail.gmail.com>
References: <20120209092642.GE16600@linux.vnet.ibm.com>
	<tip-2b144498350860b6ee9dc57ff27a93ad488de5dc@git.kernel.org>
	<20120521143701.74ab2d0b.akpm@linux-foundation.org>
	<CA+55aFw5ccuvvtyf6iuuw-Finr79ZkPxgCxL5jNvdnX5oMYkgg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_11_10_07_+1000_1F.Lbx0mFuMra2bl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_11_10_07_+1000_1F.Lbx0mFuMra2bl
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 21 May 2012 15:00:28 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Mon, May 21, 2012 at 2:37 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > hm, we seem to have conflicting commits between mainline and linux-next.
> > During the merge window. =C2=A0Again. =C2=A0Nobody knows why this happe=
ns.
>=20
> I didn't have my trivial cleanup branches in linux-next, I'm afraid.
> Usually my pending cleanups are just small patches that I carry along
> without even committing them, this time around I had slightly more
> than that.

You could set up a branch that is merged into linux-next if you want
to ... it may lower the suprise factor.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_May_2012_11_10_07_+1000_1F.Lbx0mFuMra2bl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuudvAAoJEECxmPOUX5FESDIP/2gGAQ1hIh7AkJvR5uW8a915
fpvvhpbAIflOcEOWgtWZGuquk4DTed1j8ZmDOwTh1MuY2VIeS7QU1LEcJmunhypD
MElhNShXW4q+o7qqMtBUkbZFrZ4KP6XRw2zHx0Ds8tCblPR5pPiOYuJzx9yWq76V
CofAJVcX9GyeIdnJ+xBOQ73J3ZEJ4fVolMEmzXVKQMJOnJNwmE5ggVreTodLYDAQ
CXBrvA5dvmPsQ1arptLKuqR6RlTgBlz+dKUBL4mcz9q1nj/wUf0f4jrZdqn6/z7F
OzqKSGv20Pt7IujUtuFG0iIJx5lm6Sqk6UpGZKuP9XzED6Q+H79jS6cCjVs/3LmL
6sUlHTxcnrvpLqagM+9mFOJ9nkiykDiHjUpR7d47nfp14EqkcXhJz3NZgdN09FTA
ULf4/IC+BcDn4uuWoFGJrGqdSuL0XciLLNgmqdChF1zAzXzEjEgcJKRZ/XNZ0v9w
Dzb6Er09cWBVpoJAT5G5RDapH90A8uJquUQoSaDf4Mi8PL0eN/1RIq4OiZ2c6sVv
HOhHudmlPPDyTpBcv9gGTt6Eogd/pg13qgxFZgfRqwk943Na7ythgJg66EFNWcrd
y2wk012SJl6vQXmttCrXNJna9kSBsMqdGJLWaloWF+IEy83GCkH+CDK3WX2PfwMV
GQnRw6Vmzix0XgSPpHIC
=Wo4R
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_11_10_07_+1000_1F.Lbx0mFuMra2bl--
