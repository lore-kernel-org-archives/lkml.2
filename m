Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab2AGGoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 01:44:55 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58035 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2AGGox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 01:44:53 -0500
Date: Sat, 7 Jan 2012 17:44:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the vfs tree with the v9fs tree
Message-Id: <20120107174434.ed579c80d0371c0b81135aeb@canb.auug.org.au>
In-Reply-To: <CAFkjPTndww2mu16gCa9cn7V=0t0wvYgPQ1wQGz0q0B=Fk6xQbA@mail.gmail.com>
References: <20120106134658.7589dec177541808dad20eb9@canb.auug.org.au>
	<CAFkjPTndww2mu16gCa9cn7V=0t0wvYgPQ1wQGz0q0B=Fk6xQbA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__7_Jan_2012_17_44_34_+1100_ar4I1rO810V3s2pg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Jan_2012_17_44_34_+1100_ar4I1rO810V3s2pg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Fri, 6 Jan 2012 22:38:57 -0600 Eric Van Hensbergen <ericvh@gmail.com> wr=
ote:
>
> What's typically the right process for me to prep the merge for Linus?
> Should I pull Al's patchset and then apply mine on top of it so I can
> merge your merge fix or just have my for-linus tree based on his
> current working merge (which I assume has Al's by now).  Just a bit
> confused because rebasing was discouraged last merge window -- but not
> sure how to deal with the conflict without a rebase....

Just warn Linus that there will be a conflict with Al's stuff.  You could
supply him with the patch I gave you just for good measure, but he is
good (better then me) at fixing merge conflicts and will ping you if he
has doubts.

i.e. don't rebase or even bother doing the merge yourself.  Just ask him
to pull what was in linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__7_Jan_2012_17_44_34_+1100_ar4I1rO810V3s2pg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPB+nSAAoJEECxmPOUX5FEGacP/RlkOGv42lpymblKKuxSfDia
6MVJ3U81BNqKxmejjmZRT5XxdfKzJL7SFxtXZhD6LmYaaY900GcQFNwX1hs//yxc
SwdbYKCBhD2xT09LDBNDatclHCSegde+izIscS0BBGr8BP5g68iT5QxPjQMJduey
BIQPQ/wq9i5LMhauTHAkEUCbu8/R/+a8i05klgA99tqi6uUYJ2eyhM6G+A7+DLab
54M3RLqz0iZePjlc9jHZt6Mq8eI1LGnJCWco6+nzrV1Ncpz8Q4u0jr01Bp3oV+We
Cn5BRMiBPly3N7D8nskGMml1YH6Zkg0aVRW2mUo+pKE2mnPJxm8iqM8rA4f+GFYC
lVn2s1nstUdLospY8pT/C+UjdF84GeF/Bkw7PZyG5/f5x7TKlVNwnKE68UbgAAmh
7Eek/Jd4DJ6BC0yZlG/XAi3sF8r6nYgC6dPkdv++vAciNPC1DoHnUVKMHX+HR3/w
+0Kx3k8o+lcB70dvO6ZT9ErRXcxiOIPbPE8jFwdrcvwnpUpWxUEWSrLu0cDmZKDl
Wjzcj+4dSbc6oPc0AjMEGm1uV+bnM5GJTG1lPVgdADqYv7fGZXIAVuBLzFvOzYlG
YnLQIrpIsuQb9MQyk+ArYzBveDd/s4JKSxj9RGoovBiIbAfqfskP265TdzDMUpnY
enU5U7yiNyV5smdsUBDS
=K9Rg
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Jan_2012_17_44_34_+1100_ar4I1rO810V3s2pg--
