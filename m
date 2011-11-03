Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab1KCLlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 07:41:52 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49516 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab1KCLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 07:41:51 -0400
Date: Thu, 3 Nov 2011 22:41:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, Christoph Hellwig <hch@lst.de>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: linux-next: Tree for Nov 3
Message-Id: <20111103224133.1f327c9c4804212af408d576@canb.auug.org.au>
In-Reply-To: <CA+icZUX1juRU51gXFrX7ZeKgtV9=0bmFKLYZCcuyTfW5E1SL+A@mail.gmail.com>
References: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au>
	<CA+icZUX1juRU51gXFrX7ZeKgtV9=0bmFKLYZCcuyTfW5E1SL+A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_22_41_33_+1100_nOPrrGncSQA+BfdH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_22_41_33_+1100_nOPrrGncSQA+BfdH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Thu, 3 Nov 2011 08:29:06 +0100 Sedat Dilek <sedat.dilek@googlemail.com> =
wrote:
>
> Whuzzz up with VFS tree(s)?
>=20
> [1] and [2] lists:
> vfs             git
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git#for-next

I undrestanm that Al is unwell.  This tree has not been restored since
the troubles on kernel.org.

> vfs-scale       git
> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git#v=
fs-scale-working

Again, this is one of the trees that has not been restored.

> Isn't vfs-scale [2] done?

Maybe.

> I have so long not heard or read from Nick Piggin (vfs-scale), I hope
> he is well.

People don't seem to let me know when trees are no longer needed.

> Christoph take over as interim VFS stuff from Al (hope he is well,
> too) and I have seen his and pending stuff from FS folk was merged
> into Linus-tree.

Yeah, Linus has pulled it so quickly I did not see the point in adding it
to linus-next.

> Christoph, your for-next GIT branch [3] is dedicated for linux-next (v3.3=
)?

Hi Chrisoph, is this tree going to be ongoing (but I don't want v3.3
stuff until after the merge window closes)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_22_41_33_+1100_nOPrrGncSQA+BfdH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsn3tAAoJEECxmPOUX5FEGRYP/Rpxj1EOn4Tk3L+sZ5RTcbKZ
OClb4US2irM5se6bh74M/ubsIaDZHxLoja+kIY670ivkxHu0i7ADpzh21efQ96lV
QqqQUnjupP6rW5jX7A350hUldmbmnrOpvdAWIbNIApW4ZLf4Y6OrxkaJ/+MWdSiC
LAsVWTaGV9xMIW211DHZytQNJtI+h3cwDnDwRwP8GdLFPl+sFNHWTDXp+mThU6zd
PLamuWxJhJcgg3jW9HNXSXrGEYTod7dc1JyKHRJdbOS+KCA6GV4//aMr/VKUiZ/U
fccZX40gQUrFjh/WoEQR8FtRyrvuku5NDQwQkQYWzPlLuTxBuG1Yz8Q0ag4IhMm/
99vunP4dwyU1mL+Y4O7BgVulr41VtgqgoP30mF7Fl29eOzft5kZyL/UDM9mczC/l
KaQbb+Cqii8t8tpll7cEbo7LgCl3MdlnK3ASBHdb4zSSUk4NN1Fl2SY0Db+4cpfe
jISgtDZ/O/X7ufCtn3nQc4OGg2ZhwKQ+2LfzZE/tEVsoNiF8Yq9LN0LBhZ0jFj5C
rp6wawgvnrb0onE0JgPfr4bLwGAweX1azYEN+nH2hax1uSmFvM1pNcvJVTG4QJ+e
PSun6AclhCL3jM04pxTp+pvDD+GIqs6tPsUr1K2iYVGOLtTMPO1dfmfG0I75kB5h
2VpbbKfoKMFaoRq6Nvwc
=heWx
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_22_41_33_+1100_nOPrrGncSQA+BfdH--
