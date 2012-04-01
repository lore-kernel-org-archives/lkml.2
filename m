Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab2DAMDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:03:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40607 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2DAMDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:03:50 -0400
Date: Sun, 1 Apr 2012 22:03:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc1
Message-Id: <20120401220340.57df6c1fe19ffd7070bc552f@canb.auug.org.au>
In-Reply-To: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__1_Apr_2012_22_03_40_+1000_9GSO1R4_eF56qi7C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__1_Apr_2012_22_03_40_+1000_9GSO1R4_eF56qi7C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sat, 31 Mar 2012 16:58:35 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> One thing worth pointing out is that the header file cleanups were
> nice, but let's never do them again. Or at least not for a release or
> two. They caused a lot of merge conflicts and small annoyances, and
> while I'm ok with resolving merges, it was annoying enough that I
> don't want to go through that immediately again. I know they also
> annoyed some submaintainers that were complaining to me about the
> pain.
>=20
> That said, I do think they helped. The <asm/system.h> disintegration
> (and to a smaller degree the bug.h cleanups) may have been painful,
> but it definitely cleaned things up. So I guess we *will* do things
> like this in the future again, I just want to forget about the pain
> before we embark on this next time. Ok?

Well, we may have avoided some of that pain (or at least moved the pain
out of your tree while you were merging everything else) by putting the
system.h disintegration into linux-next for at least a day or two ...

Oh, and you seem to have missed the fix up patch I posted for the powerpc
fallout from that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__1_Apr_2012_22_03_40_+1000_9GSO1R4_eF56qi7C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPeEQcAAoJEECxmPOUX5FEL/MQAId0+HvtbJ6JLFizPxyEdHrj
jYY2zVKLIp1jw+e5ggP9rxPRnRzG9Ls15hx6hW70KM8KM7nyR7NEkD1fIuLz6PzJ
z2WfcatR4WH7OJPI6JBiHcNyff8yoAk3lk43w1Zg0zF+WJ1p8e3ids9Hn6CXhX2m
AQfrbO4lk7Vu3hRQAvIjrnSnTH63a1ByVV7PjqJnochvv/CgvmReyYe6zlETcWAM
XJJeE5otC47BD3r6+sG0Fj3eDJpM0KppHvedCSqv6afREEI89mjmw9JKWIFG1xe/
YkcwwsmJ9zOn2umYr07kwf4oAS9qzktIOwX2JV/dfDllN74zjNw+rXUWBZ6QdTOL
LPinnTvn7OipzCBUEmQFxUvVo6GcooaR0eLUo3d7fjMH2cN8l+mdyLP9zU7keFwy
BouMASj17KtCwbbK6x1jc8l8tcFyUTPfY3VSIvNVwJVWuzdIlTOEIabuZsurZaMY
xFJmNKcQlExAfR353Fif8lLMexrIRS98hVg+Y78aPxIExmDHun2ugyi6ic/Zx9kP
/HCEdnUq++ua4ThEsd0tsYa+9skXsiaP/76+xtFzgcQ7s7iUIT/Tb7tOmFEqS0P4
UCMZOKk3ypZj29TSfE/Dg+fTFyZ5GNLSK8Ye5xQTfkIlSSOACGXh7Vtc34/dO/H7
HO23tc1PVmSpRZ5QofYf
=z5Qk
-----END PGP SIGNATURE-----

--Signature=_Sun__1_Apr_2012_22_03_40_+1000_9GSO1R4_eF56qi7C--
