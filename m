Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2LBWtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 17:49:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60761 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2LBWtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 17:49:16 -0500
Date: Mon, 3 Dec 2012 09:49:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-next@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Request for tree inclusion
Message-Id: <20121203094906.4cbfcfc0ad3f0319895a162d@canb.auug.org.au>
In-Reply-To: <CAFTL4hxWdV96dO_KCOnvc4O1zutvnW6eGZ950d+qwnCSHb9NpQ@mail.gmail.com>
References: <CAFTL4hxWdV96dO_KCOnvc4O1zutvnW6eGZ950d+qwnCSHb9NpQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Dec_2012_09_49_06_+1100_32ZFEUeZqgdqKDQ1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Dec_2012_09_49_06_+1100_32ZFEUeZqgdqKDQ1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Sat, 1 Dec 2012 00:09:03 +0100 Frederic Weisbecker <fweisbec@gmail.com> =
wrote:
>
> Could please include the following branches from my tree in linux-next:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         cputime/adjustment-v2
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         sched/cputime-v2
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         nohz/printk-v8
>=20
> The two first are based on tip:/sched/core
> The 3rd is based on upstream.

Well, these are a bit late (I expected Linus to release v3.7 today), but
since Ingo has not piped in over the weekend, I have added them from today
after the tip tree merge.

I have called them fw-cputime, fs-sched and fw-nohz respectively and
listed you as the only contact in case of problems.  If these are to be
long term trees included in linux-next, I would prefer that you use
better branch names - otherwise, if they are just short term, please tell
me to remove them when they are finished with.

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

--Signature=_Mon__3_Dec_2012_09_49_06_+1100_32ZFEUeZqgdqKDQ1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQu9riAAoJEECxmPOUX5FEGXcP/1QABn8+U6rxt31xSMJDy/Sf
Ag81Dfdd32kXtUQE0iRr2hI7ZNE378JKe7KwPBrwCUkobq0ODutGhWhp2jfJdEGx
ix16SuwbD0X/tWdpUS0TTz0rajW1XHw4fM66YIUsZXuCUtJLvnxV/C/h21KCKoY8
4/b9tmiBhuO37PdAhFW3cJBbVL2NIfImoUKNuCp2t43w7EfvxozOmmehta6TPzbq
y6MmDfWT7oiYzd8IZPBOSEuJ0srSzESBokKOoVlCc5J9T6L86HA8NrZYQqSG9UIp
NL4OWhJjM0nwvWvYnvFmpAoSKhrxng65ydOMGCdbPDK2K2xAFXYA8oDM3okKBQ3d
UM+ZXgTmTJLhAMEd0EREF4peqMN1MtMvEZbs05wtsLmhm9fO2UYh3Ec2a48s6P6W
p1CGzl75ySikURUkGm5cgoVlMkkEno9hUycpbTAm98Qs0j+nDAnyx0eHEpG4vnX7
8t3FyQcSr7HPJufHXi9vxHrLLhwo+yRAru/bcGQfyFTJV4wcsV/uApABoKAV2Hb1
6vpaZ7A/0NY7wQKfA0zy0CdByycpMnT/XJIPZzSjSNRfHFBkJTyMeO56hMLIFjp1
ayZTjb2cGLW7jfiz9i1R+eHm/fB/wh8+w8QCFWhzagXyEyHgS3ROAIpibwoFMaYJ
0yS8QDAMVCIiZWy9d5sf
=UzFs
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Dec_2012_09_49_06_+1100_32ZFEUeZqgdqKDQ1--
