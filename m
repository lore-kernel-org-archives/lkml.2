Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2IMNf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:35:59 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36541 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2IMNf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:35:58 -0400
Message-ID: <5051E12F.80001@kernel.org>
Date: Thu, 13 Sep 2012 09:35:43 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Leonard Tse <xiehao5@gmail.com>,
        ftpadmin@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
        leoli@freescale.com, triplex@zh-kernel.org, tshibata@ab.jp.nec.com,
        k-keiichi@bx.jp.nec.com, minchan.kim@gmail.com
Subject: Re: [PATCH]URL is unavailable
References: <CAHVxiJCv+tzx4rtL2Mu0zAYEurrSwHANwvL_bpDUR7ZMXJdAyg@mail.gmail.com> <20120912160306.GA16482@x1.osrc.amd.com> <5051334E.4010802@kernel.org> <20120913093241.GA15810@liondog.tnic>
In-Reply-To: <20120913093241.GA15810@liondog.tnic>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC8C4C26C07A9B67690B80B1B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC8C4C26C07A9B67690B80B1B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 13/09/12 05:32 AM, Borislav Petkov wrote:
> My memory is hazy on this, but after the move, what's the policy on
> enabling users.kernel.org or userweb.kernel org or some other user web
> serving thing? I vaguely remember that we don't want to do this anymore=

> but I'm not sure.

Well, as such system would be the largest security risk, it's
understandable that we're, err... reticent to have it up anywhere near
the rest of the infrastructure. :) We do have ssh enabled on two systems
that require git and release management, but anyone ssh'ing in never
gets a real shell and is severely locked down with SELinux.

> In any case, if we do, it would probably be better to have a whole
> different machine for such stuff and let users upload their stuff again=

> without touching the old backups at all...

A better question is -- what is the problem we are trying to solve? We
are not in the business of providing free web hosting -- our aim is to
facilitate kernel development. We already provide a mechanism for git
trees and release tarballs. What is lacking is a simple way to publish
documentation -- it can be currently done with kup, but it's poorly
suited for uploading and managing many small files.

We already have a skeleton implementation of pulling such docs from git
trees (e.g. git docs are published that way). It's on my list of things
to extend this to a more universal and versatile system that would make
it easy for anyone to publish arbitrary documentation via their git
access -- perhaps on a subdomain like docs.kernel.org/treename/[etc]. We
can even require the use of "git tag -s" -- this will give us both
adequate security and history of changes.

I think this would be a better approach than allowing unfettered ssh
access and upload of arbitrary files.

Regards,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


--------------enigC8C4C26C07A9B67690B80B1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQGcBAEBAgAGBQJQUeE0AAoJEI6WedmufEleSvcL/jC01LrwZNgT4iloZyrhey6a
g1EZexlEWQypQ7BKHkepdJ5Dkqek4DjogD4qwg7YUcVczqlEigpiWcGLWRDQOjub
//5SwA3Ktmk5pQHctlkd0cOwRxc3uNZYKx6BDRW7EUwzvvRmBh8uxICScnQ0j4kZ
2Rh7POr0ESOopbxx0G6sbfXRhiFLgeQPTMF94JNk/0Rkh076zYZFmE7m/93ycIS7
DbQEfMX+ADDv93mbddE10Hy5Ve1Dc22cbsktXlATlMtVItB8b1L80McKeOacFQ23
cNaSGCWSr3hZ9baspHlwGim/C1TAvC0RyOi4QtC0iqoYd5K2zxqQRldCRFtLnqF0
bO+Myc18XPC8LsNACDPufEJ2Xdbl8Mv+IVEBg3EC+0kQBlhVu/BPL8sad2/ggiT3
bKfz8N2SBW7EYLGm+D8RRNkDzCa5Vhb1WttP6VVkWHxTzL44JTgGgKq/nMF2mmlZ
Z+AChiI7lccjiLeIrelZot5ju0FUBW9T3S0TCNpvdA==
=LHvD
-----END PGP SIGNATURE-----

--------------enigC8C4C26C07A9B67690B80B1B--
