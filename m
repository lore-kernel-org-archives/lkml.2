Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2EENBI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 09:01:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41871 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2EENBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 09:01:06 -0400
Date: Sat, 5 May 2012 23:00:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Carrier <pierre@spotify.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] procfs: expose umask in stat and status
Message-Id: <20120505230054.66b0ed1461ac961a2fd1e20d@canb.auug.org.au>
In-Reply-To: <CAPXGRDmXxWr4p-S1RMRNG05nP1OEC8u++WqZY7jaPgcu7zQZtg@mail.gmail.com>
References: <1336186227-1941-1-git-send-email-pierre@spotify.com>
	<20120505145403.e73ce6633d2930ecde461bcf@canb.auug.org.au>
	<CAPXGRDmXxWr4p-S1RMRNG05nP1OEC8u++WqZY7jaPgcu7zQZtg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__5_May_2012_23_00_54_+1000_2TNhgqb.zvi.HtGr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_May_2012_23_00_54_+1000_2TNhgqb.zvi.HtGr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

On Sat, 5 May 2012 13:57:47 +0200 Pierre Carrier <pierre@spotify.com> wrote:
>
> On Sat, May 5, 2012 at 6:54 AM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> > Why not use "Umask:\t%#o\n" ? that way you don't get two zeros if the
> > umask is zero.
>=20
> Because of ignorance and laziness.

:-)

> Just tried "%#o" with v3.4-rc5-182-g71eb557 and got equivalent results
> to "0%o", including 0->"00".

That looks like a misimplementation (i.e. a bug) :-)

> So it's agreeably better, even we just don't see it yet.

Yep, then if someone fixes the bug it will look nicer.

> On Sat, May 5, 2012 at 6:54 AM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> > It would be good to tell us why we need this, of course.
>=20
> Oops. I don't have a killer argument.
>=20
> We happened to look for the information for a running service and
> couldn't think of a simple, non-invasive solution.
> It feels like it'd be useful to expose it.

Who is "we"?  i.e. what is the application that would be using this?

i.e. assume I know nothing (which is not so far from the truth :-)) and
tell me why I would want this in my kernel.  Then put that in the commit
message.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__5_May_2012_23_00_54_+1000_2TNhgqb.zvi.HtGr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpSSGAAoJEECxmPOUX5FEQLIP/2H9uROFhxpRDcFz2ivNP8Ea
PT+/nES6EaaGYkVvi0jbFc3l2HTikRSU8aXRPaz5kl6TP2nAyw+G8HWkn0JC0Plp
XScCCRVIk/TCp3kxDWQW9c4lG2IluYTuWtqoa/ywZ5TyQLoeQxNRgJDohyfZMJRD
tvZteZNQJ917znBSW1lkyss1sCYKoSvr1kjBQZcqFlQGtcJ3ZkcKQIydzqD9PVTo
vuaxY8Z3dQMI0G36pwzDvcoEyWEMpksyTczGm61tyU4wrmiDFVmwXEzwTGTd3iGz
QFXtUuqt4SCIRYYrKeMUpMoRtFKVx4OPmMCe+5GZ3ZOalSy6DvFDo0PX+h66Z2zw
MCpULMmNtzL4ZQUMEO632S8J+1HD7SQW8A8IVnkyNyz3hV5tQe09uwViZizQcQlH
lu1ymkqHEJVhwhceeKiMH+I3ndx5+IRQa984qaQ8ZI0vKa5KONPY8UI4TcfmtVpX
nteg/bY3vlIKT6/yZSZaXQDgkD4Zy5IWLAfHeGlPNsTeh/L+7K2WLmNTYwrydVet
YwOZBFOUCAZMTPbvGr87TQputzEyWmeaX6Wz2B/7ZEUm6wOB+98vyfJbSWHLYMk9
mdPwKCwJaRBkKOYSGjdHwz+A7ZbKJzaNZZiCK4X4OQiaCk7aIpet1okm1RRjkv8i
2QSFboKGN+qNd4/wOuLy
=dUE3
-----END PGP SIGNATURE-----

--Signature=_Sat__5_May_2012_23_00_54_+1000_2TNhgqb.zvi.HtGr--
