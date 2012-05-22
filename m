Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab2EVBQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:16:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35362 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab2EVBQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:16:22 -0400
Date: Tue, 22 May 2012 11:16:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
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
Message-Id: <20120522111618.ca91892dc6027f9a4251235e@canb.auug.org.au>
In-Reply-To: <20120521151323.f23bd5e9.akpm@linux-foundation.org>
References: <20120209092642.GE16600@linux.vnet.ibm.com>
	<tip-2b144498350860b6ee9dc57ff27a93ad488de5dc@git.kernel.org>
	<20120521143701.74ab2d0b.akpm@linux-foundation.org>
	<CA+55aFw5ccuvvtyf6iuuw-Finr79ZkPxgCxL5jNvdnX5oMYkgg@mail.gmail.com>
	<20120521151323.f23bd5e9.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_11_16_18_+1000_PqBwzZLlCk.6SKeC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_11_16_18_+1000_PqBwzZLlCk.6SKeC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 21 May 2012 15:13:23 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Mon, 21 May 2012 15:00:28 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>=20
> > On Mon, May 21, 2012 at 2:37 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > > hm, we seem to have conflicting commits between mainline and linux-ne=
xt.
> > > During the merge window. __Again. __Nobody knows why this happens.
> >=20
> > I didn't have my trivial cleanup branches in linux-next, I'm afraid.
>=20
> Well, it's a broader issue than that.  I often see a large number of
> rejects when syncing mainline with linux-next during the merge window.=20
> Right now:

Some of that is because your patch series is based on the end of
linux-next and part way through the merge window only some of that has
been merged by Linus.  Also some of it gets rebased before Linus is asked
to pull (a real pain) - there hasn't been much of that (yet) this merge
window (but its early days :-().  Also, sometimes Linus' merge
resolutions are different to mine.

I have been meaning to talk to you about basing the majority of your
patch series on Linus' tree.  This would give it mush greater stability
and would make the merge resolution my problem (and Linus', of course).

There will be bits that may need to be based on other work in linux-next,
but I suspect that it is not very much.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_11_16_18_+1000_PqBwzZLlCk.6SKeC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuujiAAoJEECxmPOUX5FEX7IQAKKLCtkopURcEh/15SA6cg5M
XT8R8NlyQyoMEF4PSR4k3I3Fcj7xfw/Z5hWASOh0Z2BGdtE1le/lAlM4xvzs5qYw
1OHUfQOs21Xpnhrsa2LlAvQ28KCZWsXWIHlBO+2nc/A2iyjzUupzlPuFrAAl69S5
uhArUAMOzvSRE2RKcoiSQKIZT2A/EKq9+v47vsq3JA7lL9qDIOsRkjvCqUNI/kgd
RBYCFuSMwRzxc6Vo96WlzheleFu7Zo2SBtHbg5EJdVFMzUlcNZvcIB869o/ZMDSF
VOQziCXLdT7uKwPN12OlWeZhyIDDOnV822VAy4cIJupMg3iK5JmGZOWJeS0PunE1
qqacPgm8kIz+4qhjoLiYdeoyVxN7NO3VVSl4HK8LHqBLvNza7XuvvJnLDjCZyTG1
wVub1nvYn9rankVENt56KGT0HItciAtzBJlEpLyXtEJOQ7JjXUuSl1utv7Ny6BvT
ufZkkO4ld6/v1XJqBOFvrI8MiblNnm7BEY9c8vwZ+S3whjH1TW43UQMH3MKRYNby
DNXPOa+16YIB4KTAsB3GE2f4ZBWaCqCd4TBduzADFP9Keuix7r+cMcKEJjJmqJDL
N5W3h2JncH3NKfBSM8xPQTHJosD8+cSYaoCoh1r4HPlrDGYYsl2DuFzFV53cL5ez
UrGQVE1uRIWk06VpVH9S
=W5v5
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_11_16_18_+1000_PqBwzZLlCk.6SKeC--
