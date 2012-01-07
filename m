Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab2AGCXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 21:23:15 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37747 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372Ab2AGCXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 21:23:13 -0500
Date: Sat, 7 Jan 2012 13:23:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for Jan 6
Message-Id: <20120107132300.0d299a2b7f1c84832b4c15dc@canb.auug.org.au>
In-Reply-To: <20120106154109.2a104bbb.akpm@linux-foundation.org>
References: <20120106192604.5949309aa93444ed2a9f2266@canb.auug.org.au>
	<20120106154109.2a104bbb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__7_Jan_2012_13_23_00_+1100_Oe4NivgeobU=GpYG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Jan_2012_13_23_00_+1100_Oe4NivgeobU=GpYG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 6 Jan 2012 15:41:09 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Fri, 6 Jan 2012 19:26:04 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>=20
> Did you get this?
>=20
> kernel/sched/core.c: In function 'sched_setaffinity':
> kernel/sched/core.c:4333: error: implicit declaration of function 'task_n=
s_capable'

No, I didn't. task_ns_capable does not appear anywhere in my tree.  There
is a commit in the selinux tree that removes task_ns_capable (replacing
it with the equivalent ns_capable call).

In my tree and in the current version of Linus' tree, kernel/sched/core.c
include linux/cpapbility.h that declares {,task_}ns_capable.  So I am at
a loss to know what happened in your tree.

> Apparently because Eric has today added a two-month old patch into
> linux-next at the same time as mainline moved the entire file.

That is the commit above.  But git's merges seem to work for me here and
does the replacement in the file in its new position.

> Eric, please never put 3.x material into linux-next until 3.x-rc1 has
> opened.  Please remove these patches from linux-next until 3.3-rc1
> opens.

Certainly if the above commit is not meant for this merge window, it
should not be in linux-next.

> Also, more gregmess:
>=20
	.
	.
	.

> And below is what I had to do to fix up all the conflicts between
> mainline and linux-next.  This all results from a single morning's
> merging into mainline.  It's mainly tools/perf.  I have to fix up
> all this crap so I can get code tested and released.  Or I can turn
> off the machines, stomp home and see if things have improved on
> Monday.  Bye.

Well some of this will be caused by Linus' doing different merge
resolutions than I did (in particular the cputime ones) and some may be
because Linus' has not take all of the tip trees yet (which I get in a
single hit).

It will be interesting to see what I get on Monday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__7_Jan_2012_13_23_00_+1100_Oe4NivgeobU=GpYG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPB6yEAAoJEECxmPOUX5FEyqEP/0c1R5DHTKvgyci9zZeekTM1
OmASkFBoXbgvRnorrg21V0cPupqK7hFkdSxYE2ktRthfJ4MN9bIhMQNH4A+mjJ6h
miKHkH0J5Bm5IJvUjpOvCOvSSr9Tt18OXDH+vCkzC2A+ullHQZ+ZMvas0VzM1GW3
asjf5GQ/kTxNZQ6G1WDgCADRnvXcfjCnsSJc6DSvnKlVjGjDDdwky7nOSZLldsXk
agn2VToViyu2jMEdAk8F4OBTyxHmrwuGXlyYkw/qITQEobeVLVB9pt7uyeM6gZNE
JxVwWvezaE4CNqfirMlfTjQPIr/KRf7nOS2afFCXAOhfyKNtHzRy+tn17WmT+9wj
WvvoSlPsi3Xx1ocoHSrhBgo07pREwhEkhvY159rfworMPIJizVyblOrxwDUEIwdY
J6qT+6exMtS1mYDPUXrTNkM34Yg/FWSBfeBWNACuCmxJuRA+AYsk+4lz5aEWJaku
EVPMIgr40um7e/+fl/JsgCoD8f094fosqAUPT3UwoW6142hQNjsw04pXaVUV7Jnm
jFiICGPnoZ2ekmDFRfJyZL9VGokFZNfsZDGsVPmsJwRuisKC42aWakMmyvEgcOru
hFCpyQjN8tSde33mjxvNI+tctpriZJiCicvXXTyC11rXHy+JqSzKoX4DHDmXnP+1
CeBfgHvn4sEPg9Hf4mrC
=TFXu
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Jan_2012_13_23_00_+1100_Oe4NivgeobU=GpYG--
