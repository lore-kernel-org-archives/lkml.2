Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1FKEm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 00:42:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35046 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab1FKEm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 00:42:56 -0400
Date: Sat, 11 Jun 2011 14:42:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-media@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 8 (docbook/media)
Message-Id: <20110611144245.8b893302.sfr@canb.auug.org.au>
In-Reply-To: <4DF235F0.9080209@redhat.com>
References: <20110608161046.4ad95776.sfr@canb.auug.org.au>
	<20110608125243.e63a07fc.randy.dunlap@oracle.com>
	<4DF11E15.5030907@infradead.org>
	<4DF12263.3070900@redhat.com>
	<4DF12DD1.7060606@oracle.com>
	<4DF1581E.8050308@redhat.com>
	<4DF1593A.6080306@oracle.com>
	<4DF21254.6090106@redhat.com>
	<4DF23271.7070407@oracle.com>
	<4DF235F0.9080209@redhat.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__11_Jun_2011_14_42_45_+1000_fvr6BalpxVt.SzBn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__11_Jun_2011_14_42_45_+1000_fvr6BalpxVt.SzBn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Fri, 10 Jun 2011 12:19:12 -0300 Mauro Carvalho Chehab <mchehab@redhat.co=
m> wrote:
>
> PS.: A full build against next is broken:
> $ make -j 27
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      arch/x86/lib/memmove_64.o
> gcc: arch/x86/lib/memmove_64.c: No such file or directory
> gcc: no input files

Was that a build starting from a clean (object) tree?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__11_Jun_2011_14_42_45_+1000_fvr6BalpxVt.SzBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8vJFAAoJEDMEi1NhKgbsPyYH/jHFMMRsP68jJfGuNQA99zCN
10B/tRGHKw6Rua+cOpIhhvPeNQXFTWgmlcnxE00NrAr5Iao8itj/jKxhxW3rhxvN
0HvytGBn+tB+eRFxYqQlfSAVpfSiY1kO0GhmukneSHtpzwpY/3zriNN2ravJlpVo
RD7O3GGDHMQ9UrN2DR6n0Da8wgt6kVPvvGLr0qeVO0zaAnyq10s7oLb9th9GSqYW
SRS+67TlDu6O9Kh1te3N2MIQ2EYQEnFzVJ+BTUINVHrCfFp16hXo5VkduTYb3pLb
zfSqR3JyWHXNh7fWYOS/pqFXakQkF9rcrUFZyFG1hl8SgKhjsVpnzhhsRXmkjDI=
=9PtD
-----END PGP SIGNATURE-----

--Signature=_Sat__11_Jun_2011_14_42_45_+1000_fvr6BalpxVt.SzBn--
