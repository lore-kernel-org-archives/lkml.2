Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2LJV3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:29:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37903 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2LJV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:29:01 -0500
Date: Tue, 11 Dec 2012 08:28:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missing tags in my local stable git repo
Message-Id: <20121211082852.5e89e840a8a79c503dcb0763@canb.auug.org.au>
In-Reply-To: <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
	<1355165264.17101.233.camel@gandalf.local.home>
	<20121210190247.GA32119@kroah.com>
	<1355166920.17101.239.camel@gandalf.local.home>
	<CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Dec_2012_08_28_52_+1100_hQBN=J9=6VXO1y2i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Dec_2012_08_28_52_+1100_hQBN=J9=6VXO1y2i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 10 Dec 2012 11:30:55 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> Moral of the story: be *very* careful when using alternates. Only ever
> point the alternate file at a *real* repository (not another one with
> alternates), and only one that never has references removed.

Does that mean your tree could now be a problem, since you have recently
added and then removed a branch (some of whose commits were not eventually
committed to your master branch, I think)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__11_Dec_2012_08_28_52_+1100_hQBN=J9=6VXO1y2i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxlQUAAoJEECxmPOUX5FETIEQAJJ/bvQFgcrEZ0Hrjlhwg8r2
myWEbM+7+/2caGKMju3NP8rloz6jd/wHfE4iG4cHeXwLo6jE2k4vWVEe4CFgFHOU
DOEW+DV0s5XMWdc9ZuseZeWo5b+wnDkl3T68kmdieUOoDndE0opSAAdmzXSWRj/x
tCxbM4i99iMVAxIDz3ykqHVU4Vwwl6DxQ1bjEVvcz9f37DHZPCgIzWg5qQbgYqSa
gfOQjYUlgm4QZ0c9jtLr8gyDcJdRgQ6I8SIRFp0DfJsSjcoo8lpCmth01jug6H/E
JCzf+J40N0Iz84CvOT4hMC/0doVgK4mW5IhD4yHkEZhcJJHROaslEfqPjKYjhjER
vFVlZNP4l72hpNdGt4KJfkEueiUHojVV7hPmD3oI0eK7OMtkCiKUrXx3jzxWshtm
rsMNSZ5qPoo/pZuNYF3z1AAFv95FqLbA87sO3q+zBPvurHt9D2+TYIsCX9iyzonJ
vHyzJmeNE6TjSyKmtEZaLDQJm5w4SUMkl7QeYrU2hbt6CyRdHlEPR4ChOxx403qt
7egsA1foqD6yZm5125xDIp2JiXlEEX+sb8e9dWJANXq71IsFjY1whLUwUyzqmApO
TXB21ZvUbS5BaaY/lErU7ipT25IIVuc10LrQUkj+m4k/H1C0VBecnxDWuvCOMyqf
HvBGuNmkS5ThYd3hKo3h
=WtsN
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Dec_2012_08_28_52_+1100_hQBN=J9=6VXO1y2i--
