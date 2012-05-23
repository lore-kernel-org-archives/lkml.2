Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab2EWAhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:37:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42177 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab2EWAhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:37:50 -0400
Date: Wed, 23 May 2012 10:37:35 +1000
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
Message-Id: <20120523103735.6fe9c1c3924a62b1e8d45ff8@canb.auug.org.au>
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
 boundary="Signature=_Wed__23_May_2012_10_37_35_+1000_lh_W.DnBH1B2fc8z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_10_37_35_+1000_lh_W.DnBH1B2fc8z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

I have been thinking about this some more.

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
>=20
> Documentation/nfc/nfc-hci.txt:<<<<<<< HEAD
	.
	.
	.
> net/nfc/hci/shdlc.c:<<<<<<< HEAD
> net/nfc/nci/core.c:<<<<<<< HEAD

What two SHA1s did you try to merge to get that.  I can get some of it
but nothing like that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_10_37_35_+1000_lh_W.DnBH1B2fc8z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvDFPAAoJEECxmPOUX5FEt5kP/jjvimQqUdiAB6uJMszVjHh+
2/ky23rcYz0UYnQ1iG7iLfPQj7P1Nl2rfzmMmg3So9Q/527XiiT0wf/12itzNNC5
KGST4JSW3sgvnFgwj8YORAuucx1LDpUSwhgMPKsoZ5kLGx2RVdPKKlN+vta6t3BG
doco1NzSJCPUnQnUZM4Stly1/Bw4J+7gpnJnK34eucjLLBH3wQh4KdHGOfKqZgVR
noOOMT0POngzrV3Q5z9Ty+cLAfciquoL35gdIytEBeehuzMacddawpv/7Zegp+Ta
oqsemEtV7YRrZHHjuiPXf1cT1QhMXeB4oFlqgckzvrzfYCoxNUc7m6UN0r+p87ep
gOe1XYQa8cmlFa4rHiw7jIZukn/av1GWDUhyypvt7A0sEAJWN+h7IKn+THbzdw8e
ZVp4KAquhA56qOqFH2uITKTj2OM+giZGSow7DAWznf0LfkmXJryacbm02UvkV8f2
jGEhViWRD115kBy2uNnRqwGuFUAllcWlZP7SxX+eRRTbhkghi7VUVy3rEMNMKi7B
zwh6jUjLq2Bk6MYPARc1rLRzBIeGK8tnELBZtC8Hh0+fGMn/c0NNyVyF46ozmLgZ
VVOsxSBQ+DFQmzYZtNVSDXGEovkL28tHBnTCxbXexH+6/JKjRYO/K/J26vYSBqlv
afA3DPD19KjMrRLl1YSw
=63Wv
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_10_37_35_+1000_lh_W.DnBH1B2fc8z--
