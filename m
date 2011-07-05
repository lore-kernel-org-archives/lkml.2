Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1GEGbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:31:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53274 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab1GEGbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:31:35 -0400
Date: Tue, 5 Jul 2011 16:31:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Christoph Hellwig <hch@lst.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: fixes while rebasing the akpm tree
Message-Id: <20110705163121.608aa8ed.sfr@canb.auug.org.au>
In-Reply-To: <20110704162816.fef0b1cb.sfr@canb.auug.org.au>
References: <20110704162816.fef0b1cb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Jul_2011_16_31_21_+1000__P2U7Jzj/XosJdZ."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jul_2011_16_31_21_+1000__P2U7Jzj/XosJdZ.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 4 Jul 2011 16:28:16 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> While rebasing the akpm tree onto today's linux-next, I discovered the
> following:
>=20
> The patch hfsplus-add-missing-call-to-bio_put.patch appears to be already
> applied (as commit 50176ddefa4a ("hfsplus: add missing call to bio_put()"
> from the hfsplus tree).
>=20
> The patches
> x86-mtrr-lock-stop-machine-during-mtrr-rendezvous-sequence.patch,
> stop_machine-reorganize-stop_cpus-implementation.patch and
> stop_machine-implement-stop_machine_from_inactive_cpu.patch seem to be
> already applied (as commits 6d3321e8e2b3 ("x86, mtrr: lock stop machine
> during MTRR rendezvous sequence"), fd7355ba1e93 ("stop_machine:
> reorganize stop_cpus() implementation") and f740e6cd0cb5 ("stop_machine:
> implement stop_machine_from_inactive_cpu()") from the tip tree)

I have removed all the above patches from the akpm tree today as well as
x86-mtrr-use-stop_machine-apis-for-doing-mtrr-rendezvous.patch which is
also in the tip tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Jul_2011_16_31_21_+1000__P2U7Jzj/XosJdZ.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEq+5AAoJEDMEi1NhKgbspasH/36zYep8O37/rQzdQMazCNpp
f83WfpxKJ1DKATcuKQje9NlKbI0WEfZpd/eNb7X5lWeW+9Sti24vvXKhKtMVYfZB
4+mY0+x/Ux6kxiqldmdQ8XzuUFYflcP3Ct5zAZQYAdXsJM5T6wmEtP+EW+LY+ZuK
8armJq3YP8VkvpBlHYoLLeb28ocPAZ/0+UHMvR6pmj18w8qsMrRBTs8hnZrbBkZ0
vrYQqxkiJwzp50ciftbWxPhu6NttCQ/6Kjxku6OnFzMCjc+En8bYPZM0wWy72SVs
OSPErey09BSNsQdBqfk8pBNw8GlY41N3ET5ENBIVzIoh/8N3UJNdV6Q09f1wo1I=
=Ywwr
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jul_2011_16_31_21_+1000__P2U7Jzj/XosJdZ.--
