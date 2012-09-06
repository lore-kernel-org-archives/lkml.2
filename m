Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2IFFTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:19:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47743 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2IFFTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:19:54 -0400
Date: Thu, 6 Sep 2012 15:19:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, mark.asselstine@windriver.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild rc fixes for v3.6
Message-Id: <20120906151951.8c30cb06fcb20412910006d2@canb.auug.org.au>
In-Reply-To: <CA+55aFzBsKBmVMRiJ8yuML_QVQbfa2ZqHU_fh3_wS3YhLTv9fw@mail.gmail.com>
References: <20120903191801.GA23227@pobox.suse.cz>
	<CA+55aFzBsKBmVMRiJ8yuML_QVQbfa2ZqHU_fh3_wS3YhLTv9fw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Sep_2012_15_19_51_+1000_6jk4I.+/uZq.Ri5+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Sep_2012_15_19_51_+1000_6jk4I.+/uZq.Ri5+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Wed, 5 Sep 2012 20:32:00 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> On Mon, Sep 3, 2012 at 12:18 PM, Michal Marek <mmarek@suse.cz> wrote:
> >
> > The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf=
96ee:
> >
> >   Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)
> >
> > are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git .=
.BRANCH.NOT.VERIFIED..
>=20
> There's something wrong with that repo
>=20
>  "fatal: Could not read from remote repository.
>=20
>   Please make sure you have the correct access rights
>   and the repository exists."
>=20
> plus that BRANCH.NOT.VERIFIED thing looks bad too (and is probably relate=
d).

The kbuild-current tree in linux-next is

git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

and it has those 2 commits in it.  So script update needed, I guess.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Sep_2012_15_19_51_+1000_6jk4I.+/uZq.Ri5+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSDJ3AAoJEECxmPOUX5FEE1IP/0L8eED5IXFtDUUgtuDx2hDc
Vvc0VDrDni5M1iYSQu53pG9DFjWzrvGZVElxZF4RSfV2kCe5QuxvVhe7ZfccG2d6
ukLjiaxw3nUUv8XXfY+nh97Nl2dw7q6cYXJJI5ab/bLlvj07F9IErz8QHKdMDACt
tAukfU8KaAEORUivzc1Vs4CZrWWFAQcudr/JE+kA8UV0216T0L2eVWYKqbUFFcKg
YHbrPm/6S8R8WcFSu5y4wsp2XjeJEhO6edmVZmjDhxYMUK519A0/GaiqBPsE/Lph
eil68oc/4UR/DzMhtGyxnOY8bHB8DDWxt6qG5Bmchf18GUUK+7Q65jz0ql9dgQai
fPIqU3otLh7Xsk7i8HIB82Aavr9CREHPkOQTzT0B064p714x7BlKI8mqWPlF+XAy
tC3FPF3o9RWpr4NsydwdKxXfsazedYl5Pif1yj70sS8TID2gh1VYMpT/yNdte1Gr
UBrKF74Tiayso8CDEgbKTa7X9O6ODnnUqmXCMfEnZUBap/kVveQH7und+h7GCbwX
Dc4a9eEy4gWMOQ2CefTa3ON7+l9TwpYd1guupadxqvxahG7gxh47nZ8IgZj0OdvG
zoYzHAVKHoWvEqWvuBnILlDku4BtzNU5NO1Q3iPHCp7IXSPYYKSXcPq4R9SVltkw
4rtyspCxSf4cRwPD7LUr
=Wrpd
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Sep_2012_15_19_51_+1000_6jk4I.+/uZq.Ri5+--
