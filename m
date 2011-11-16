Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1KPDgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 22:36:41 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54683 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1KPDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 22:36:40 -0500
Date: Wed, 16 Nov 2011 14:36:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: kvmtool (Was: Re: Linux 3.2-rc2)
Message-Id: <20111116143632.914b0f0cc828d90d6ec371f6@canb.auug.org.au>
In-Reply-To: <CA+55aFzWkXNtLe4jxuXfTJzbXgDF+ig2OuGY3ca+nNCJxAtOZQ@mail.gmail.com>
References: <CA+55aFzWkXNtLe4jxuXfTJzbXgDF+ig2OuGY3ca+nNCJxAtOZQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Nov_2011_14_36_32_+1100_qgT8nYfYDi1SBa32"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Nov_2011_14_36_32_+1100_qgT8nYfYDi1SBa32
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Nov 2011 15:44:07 -0200 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> And for being an -rc2 release of a pretty large merge-window, it seems
> to be quite reasonably sized. In fact, despite this having been the
> largest linux-next in a release in our linux-next history (I think),

That is true (see http://neuling.org/linux-next-size.html).  However,
linux-next "bottomed out" with >1500 (non-merge) commits still in it.  Of
those, 900 are from the kvmtool tree,  So, has there been any decision
about whether kvmtool will ever be included in the upstream tree?

I do not want to reinflame the discussion and am happy to carry it along
(it doesn't really interact with the rest of the tree), but if it is
never going to be merged, then I may as well drop it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Nov_2011_14_36_32_+1100_qgT8nYfYDi1SBa32
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOwy/AAAoJEECxmPOUX5FEy3kP/0bJ5Km5qDQu7KBWZ8gUwDoP
7O0tiTZH4nkuMl543alGlBvhunVUCrECrnqR7slpCqxt4K105OEtA6oUO6QKLQJW
Inh46izMRTlAt8dZIqzZU1K0Bf/v4bMVCnBmvhEiO0Cubl8Csoqgn7R/Bbbdiri4
BlTtu7Y/BLUKLu2AlV0dYXayhvUpSDGRhy40xJ2E/+W7dDlOUafSa+H86JkLVt0f
BM7F9b/5fyeeG/e27BFQgHIx2bKgESwpQIrrfUQr5Vvw6Fcr9DqNlh/C98qcqUQk
1VWCJGCwVt/bUPw4nYrYGwvQe4COs4hUiAD50XzXsmnEhYNx2//NbjYLDVpMhIHm
ETXL7YfK/9X4lWT/M9BGGSRIDrvwGtQPPyzqx015z08sNtLd2N0DYLZRtnbw641a
htLOebWjKN7a88qgX6yNvTI1c+5vws49ewWOwG+fFSy7l6ift16Qh14saWJWcsrv
85ntaBYvYWd7kMU7LclrzvYqMk0TolIfUEDmkdiRRz74gTW0J0YnoBivqw83lrNW
qSg66zd7SkvYbKxWmLIme5SIhkTX/23nRGVHMPR6HXhITqIctliQeTSecRD6CiR1
4lksSq1cnp3Jl7Zp4HyvebVERMcePxNtGrGcz552rpttgDS5inXzyEETHuazRO07
jPfvyf9+LksK8ytMopQC
=ZSKg
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Nov_2011_14_36_32_+1100_qgT8nYfYDi1SBa32--
