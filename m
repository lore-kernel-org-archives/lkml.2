Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1KOB7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 20:59:50 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52309 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab1KOB7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 20:59:48 -0500
Date: Tue, 15 Nov 2011 12:59:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: New Char/Misc tree to be added to linux-next
Message-Id: <20111115125939.dd90968640fc7c50bd9a4c77@canb.auug.org.au>
In-Reply-To: <20111115001419.GA31817@kroah.com>
References: <20111115001419.GA31817@kroah.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Nov_2011_12_59_39_+1100_NeIaZTS=Lg/ibStP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Nov_2011_12_59_39_+1100_NeIaZTS=Lg/ibStP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 14 Nov 2011 16:14:19 -0800 Greg KH <greg@kroah.com> wrote:
>
> Arnd and I are going to maintain the drivers/char/* and drivers/misc/*
> directories with the goal of getting them under control, or at least a
> false-sense of control :)
>=20
> So could you please add my new git tree:
> 	git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
>=20
> which contains the two branches, "char-misc-linus" to hold patches to
> send to Linus for this merge window, and "char-misc-next" to hold
> patches for the next merge window.

OK, I will add this tree tomorrow with you and Arnd as contacts.  [Aside:
did you consider naming the branches merely "fixes" (or something) and
"next"?]

I guess there is actually quite a lot of scope for overlap with other
trees touching stuff in drivers/char ... just something to keep an eye on.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Tue__15_Nov_2011_12_59_39_+1100_NeIaZTS=Lg/ibStP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOwceLAAoJEECxmPOUX5FEhUgP/1Vn8WhUq36JDspP//OKnBoG
0z2Vsuv7E7la0X8i0mXBMT0aF7+oK13BRmyUk0f4xkm6W3xxw+BhGjFL4C40kO+a
otOyQ7k8uZrcJQ5wTeKhm7v0gS/2LeVoTjYlFcTETtwj5keGobIUMh6i3RNX4cMj
qwCMxkpx77/GhGghR40JkYxDA9JVAfPrVVaTleGfWnBkf11wteenej8Mp44xDsNV
S5Pcpq+1YrZX2XOP6t5OFtw6TvvBg79h+JUJHlHxm6nITmCGrn+tHAXPAWCywzHy
xj/osVzvupWlLO6q2cdZQEh2dnm5xVPzqXDA3Ezm6ulLbSbnCXzrPScN2QUMZCu8
1ueJVEqoNn51fU4P9wWB7AJOLawbqsXLchdev0ahAvTqzuEwd55Ibd88cpFTdp+6
m1jBAXZdUHM3UHB4ez2DjGWM9MHhh0/FtNWAVthXz9jSoWuB/p4ucsC1B8A9lwW2
blRIcw+xsMKLcYVLt6gwQRq+xTWn+2fR8/r7GZLo6aHacBKUBpF5+PoeHfd7OCzm
r81w4VyVt34WZ2haeWjCUEtY33Sh7VOegcusY15CpswmIuBoW0Li7By+DFyNpa7j
FB90IxTe/VswF/nfim1easneR4H1aJKIMHzKMbGSkpCZlcaaXJADiN8uOUsv7byi
1NsEHIOUHPUmyFde9/36
=qqa9
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Nov_2011_12_59_39_+1100_NeIaZTS=Lg/ibStP--
