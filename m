Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2DYAAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:00:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55086 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab2DYAAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:00:17 -0400
Date: Wed, 25 Apr 2012 10:00:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, Rob Lee <rob.lee@linaro.org>
Subject: Re: linux-next: clean up time
Message-Id: <20120425100002.a288b8b25dee6cecf813a69c@canb.auug.org.au>
In-Reply-To: <4F9722CA.80403@goop.org>
References: <20120402112009.3477dad7deff0f4d87f49b29@canb.auug.org.au>
	<20120423164859.082b5c53b5d9bd9a524ec864@canb.auug.org.au>
	<4F9722CA.80403@goop.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Apr_2012_10_00_02_+1000_r6sxjq7e5PnFLL1."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Apr_2012_10_00_02_+1000_r6sxjq7e5PnFLL1.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

On Tue, 24 Apr 2012 15:01:46 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wr=
ote:
>
> Are you pulling from xen.git upstream/xen?  I just updated it to be
> current Linus master, so it shouldn't conflict any more.

Yes, I fetch branch upstream/xen from
git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git and, yes, it
is empty now, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__25_Apr_2012_10_00_02_+1000_r6sxjq7e5PnFLL1.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlz6CAAoJEECxmPOUX5FEDCMP/2MEVG7K8zd0nCqsDaH/fD/f
RBjLDe5JwSPEDkY9mFJAiS4qhIVNItefqaZO9RzcODT+4nfJAVyp48TXgTB+WS98
AFUYKHM6cFanPlLbUMIzxV5ZVZgDGiN2apbg4fcn9vfkCYBJNzm0ozaABm3xQpDQ
J0LyLiRHmzxDHamgqV5rvKTTJakghV7g37B7X6uq5LawYaF6CRk0jH8/JI0nwO9D
Wb4p22DqkxihG11JrCmpFH0SAozMO+x8h3QaUJ0H7XJyjt9tP6IO9xaNYpapEd65
gqIrSE4OoxmBPsoLZcx1q14IJVb81ccY8WWkKjlxckxUTziETU7itX6cFCF5ehZ/
W8Yr4OeePr61FoEC+Q7EXyYjXjDiScCqXphCbdGDjX/yPRxB4D8ERabFUBMxL21j
+ZCEHQYBZ8rhX5/mbN4m6KEK3a/akT1ZTOHzlqn0oSac4Vpic0KFwEAL7xzmwD7C
XVQilu4PGwJJFvpPA/s5nPaIM1D5j+SS2iWt4/EKTNFsU54RJHGTn05Le+R+sIdB
x5KeGhkGjKNLm3IsZmt6ZE5D6kEVD3814K4/KzMiHeMjNfvqm/DX9UDBkiWub8uo
7T8cT+NbdDAS41IBIjYIC9rEzj8M4NXJ7tpldjaXJn4QKle9Xxd7rePl9ABJz66n
88Ky7oUiCaDbUvirvBh0
=aDPw
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Apr_2012_10_00_02_+1000_r6sxjq7e5PnFLL1.--
