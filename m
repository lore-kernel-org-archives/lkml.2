Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1LNGvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 01:51:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39342 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1LNGvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 01:51:10 -0500
Date: Wed, 14 Dec 2011 17:51:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the cgroup tree
Message-Id: <20111214175101.daac0549e5ed9d766c3a9bb5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Dec_2011_17_51_01_+1100_BPp9pIl9ZdQeTu4b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Dec_2011_17_51_01_+1100_BPp9pIl9ZdQeTu4b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpme tree got conflicts in several files
between commits from the cgroup  tree and commit "cgroups: add previous
cgroup in can_attach_task/attach_task callbacks" from the akpm tree.

This got a bit to hard to resolve, so I dropped that patch and the
following from the akpm tree.

cgroups: new cancel_attach_task() subsystem callback
cgroups: ability to stop res charge propagation on bounded ancestor
cgroups: add res counter common ancestor searching
res_counter: allow charge failure pointer to be null
cgroups: pull up res counter charge failure interpretation to caller
cgroups: allow subsystems to cancel a fork
cgroups: add a task counter subsystem
cgroups: ERR_PTR needs err.h
cgroup: Fix task counter common ancestor logic
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes

I am wondering if that patch set should be included in the cgroup tree?
Alternatively, you could provide me with a new set of patches based on
today's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Dec_2011_17_51_01_+1100_BPp9pIl9ZdQeTu4b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6EdVAAoJEECxmPOUX5FEA3EP/0SNSUN6Ezd6rIWpBNS3sjDh
sCtCYUaETv2QcMu/VofCbFRYWW0dmdw9zlbOVlN9FXZIW/0NvEI3LofjzFUTdg4k
zfWe7WgJ/A3mQafcXoowlmctB5CCzHEKrHDZ5pIVZAskOXT88uxcCRWPBCdrGuzl
DLnh4HojOJw+CYFGWjX8anI+0VffjF+4ml5PVsMEzE5xS/Zn8Q4qvBESfIm8ozIF
iTon9yKntiJhbfY4zWax3aFz1as2GfIMIUUbbGvnqAi5n21S75Z2S56LY8wWwnyp
q9VDaJSB3IqMC0RaEfLAfEHbCrigOAx1VNUhUsErtQhwPewscRvjJp88xj6ezoxX
HXNiHAhmvh2ufKx4bu3wQCKPMQecDlkO0TiFTg2RAXOu+i1wNt52MLNIM943d4Px
8y+JDdDYtXodL59q8trC14M9VUkcoyBtLU2B9trnP1rIGp4wbs1OTJUpJRufopz4
nAO2xNtF/e8OQmAZLIRYtD+q77rkfR+/JrmsmbOMcRkpuveBYb2MpAYLzRkss4yZ
d5ERnZSGN+zmjenbMjoYHZ34BpwavaPaViUNw2pDuDUTdOnnvKm8Cc+9IigEXxfS
HSqGGu7QbmjVt9qTG8kTvadlRWwn1Bb9Q5NoaWjTe1Njdpd82MEoAVh7h8XqsUmC
WMfid3YaPibhvX10MzJ/
=adP6
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Dec_2011_17_51_01_+1100_BPp9pIl9ZdQeTu4b--
