Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1FGU4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:56:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48994 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab1FGU4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:56:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -mm] ptrace-unify-show_regs-prototype-fix
Date: Tue, 7 Jun 2011 16:56:52 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org
References: <201106062124.p56LO6Hn023286@imap1.linux-foundation.org> <20110607175142.GA29525@redhat.com>
In-Reply-To: <20110607175142.GA29525@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10923838.mZAkv3G6IS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201106071656.53725.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10923838.mZAkv3G6IS
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday, June 07, 2011 13:51:42 Oleg Nesterov wrote:
> (to fold into ptrace-unify-show_regs-prototype.patch)
>=20
> No need to declare show_regs() in ptrace.h, sched.h does this.

thanks for getting to this in spite of my laziness in not doing it sooner
=2Dmike

--nextPart10923838.mZAkv3G6IS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJN7pCVAAoJEEFjO5/oN/WBN+gP/jvCrylM/vmbW4zNdHIkIopY
z95Df9ZeWnKL2VbhGyKzGsUuQQImSxpj8fZPyDTbtJbG0r2Qh/EXnE9yqgPj/ZpO
yF73qhk/AnKhLfTA7RRMANtfMpXfuqsE+7RRysITJcnWKTZLVj3smVNVJmdmtJTS
F7OQtQ0eA6EjQ49BcakN1LW8SzI7yZlhtgRuxPaX/3qm8NKunSdFhpFqkFDgvIuP
1ArVW3D3FvDXQpabflGhXoVUuiDkGVOkhIyucU1pDlstB5+Q3clxpOghQUWKyH1P
zYRl4cWfpHjvnk+PUPC6kjkFiHkAHDa/4Lo6xoegh8uR0PduFqYl5+pC3HlzoXCn
EMcbDMQgX7O1NIxySdjaQwQVG7ScpuQZEdYvQwpc9vOCj80OtwXbMJorfjU03fli
Ij6eTgKCqCeCs0NqVj59Cd64ZENwtmiE9IVnVZosikx5I4KmEh4nQj5WU3s/YiKV
UPjfrTTKigMbYdUA2KyG+tN72ftT5FPjxkylGZf4Sy/Z7qZCFtM307X1vPuo++vv
bE07Duw4qTf3cLXBDabc7IDNKXQHgWGoiJP+ZTS32P8gCJZo6RyEVIs1OB2We3Jj
4kRVrCnPRiKID5SdYxsnSQOuDXrXcAetkfAMeeT/dGLgHUOYuuz+ilBHi/i91/Al
XlmEsiQgXNYh9NH4AxSN
=Mm8v
-----END PGP SIGNATURE-----

--nextPart10923838.mZAkv3G6IS--
