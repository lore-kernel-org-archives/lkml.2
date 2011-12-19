Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1LSDUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 22:20:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50092 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1LSDTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 22:19:42 -0500
Date: Mon, 19 Dec 2011 14:19:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20111219141929.e27fd6b6ac0b9f6ae33f89c7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_14_19_29_+1100_U=mnUbijSZNrzGYw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_14_19_29_+1100_U=mnUbijSZNrzGYw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "ioc_cgroup_changed" [block/blk-cgroup.ko] undefined!

Caused by commit dc86900e0a8f ("block, cfq: move ioc ioprio/cgroup
changed handling to cic").

I have used the block tree from next-20111215 again today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Dec_2011_14_19_29_+1100_U=mnUbijSZNrzGYw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7q1BAAoJEECxmPOUX5FEJLUP/jlWgIID4FEsU5DcZq6PReWN
69+nyF8zhgFcV9HJ8XgptXIUIvph5opjwOoIdhI4pha4s7wDo5ptJuQXhr0w9DRO
S1J0uT5k8xjILubmHCRnpS4SseMdteObglUy3GrHQPTXyEx7SXAOKGdGZyu3XjQE
9Hp1fCZr0eoARZk4Dmph9ucGer+h4Cn6ZPFdnNqnC1wm7b/Dv4gSTgFrGBzJAIxE
PPWMDlmXdv3Udo6NQTaHoxMI+T8rjADqZtsnSpaNMP4QyvlNh+fbzqi+Yk+mJF2v
JwELC1OXXXRODfrDJr1SzgJdBSENHSsLoO0zfZSg3f/ruKQe96GdXa0TNS9feY0c
8Q+ltiP0aQs9UZ/bYZV+r89w6ktr4ZOk3PSTSgF32KmJDV7btM8k8t0PyFXuSg8h
fKvoJh13RLirzCubDNPJCJlJKTTAyJNWgNVpgUfJ9pMTWoj442L4okGslfvAsKgv
m3jyzL5oelKr/aFcYCVz2uClFKeW8fp5YW9E+bb55dcN6XuGkPaG6XevLmUgX+y2
PYkjE8gd+p7xXkDY18WN7fHZpjhjChyRp6Nk1oALGtTiXHXqy1G7CoBua+f8qeYB
aqnOJZyxnVuhmgKONdNxCvcgo0gGuGpngJtKYqDgfHiRB1EavLAayVTd27GV/Beg
PX+Jee4jSx9HthWZfjxD
=lAM4
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_14_19_29_+1100_U=mnUbijSZNrzGYw--
