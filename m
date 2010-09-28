Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab0I1ACg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:02:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38792 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab0I1ACf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:02:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: libc-alpha@sourceware.org, linasvepstas@gmail.com
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
Date: Mon, 27 Sep 2010 20:02:06 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
In-Reply-To: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9187770.lI0LbIzmBv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009272002.07467.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9187770.lI0LbIzmBv
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Monday, September 27, 2010 19:26:29 Linas Vepstas wrote:
> -- Current glibc (2.12.1, as well as the current eglibc) does
> not appear to use these new calls anywhere. Instead, glibc
> has generic (non-arch-specific) implementations of msgsnd
> etc.  that use the old NR_ipc interface (see, e.g.
> sysdeps/unix/sysv/linux/msgsnd.c, semget.c, shmdt.c, msgrcv.c,
> shmget.c, etc.)

did you miss syscalls.list ?
-mike

--nextPart9187770.lI0LbIzmBv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJMoTB/AAoJEEFjO5/oN/WBzgkP/1DcafFZzOsGiGU67NzSUeZn
daS+2dxeXJLhp2PNg1skWGWRQJX7sQjVnf1OrdQ6z7948OUnBRorHXpkMh6vQLcg
KCVLGfVeuBaC3GYEDUzuQiAl2FujRVKEI9vqdHm+SUkkh05uPx3MIU060NEigQya
bnudk+NB6cS8ytrSP+Zyy3+wlLyzvO9sUympAwumq9iqhlWIya+tq6rS5sWO789f
xmXVuERo1RYzMllzg+fLZW0VOYKC5jYBgXvRDb35l88bhDl3rSRTrp7uFU6+dQDE
B/nmnlL2ip1Bw1NviKyq2uot7OXESQEGZklZ4ybK6yjbxVDBcvAAclumE0cMkgs0
bgIBcnRAwFHlD7yDQkDsMuaALKkwfDjlWPb75PZmzsqGzJnROPKEUYN3yu6F6CDW
n6xzDWr5xHLPDrkVQ3KNdhdIB5PLkaKbuTxyyH938JX2+6NoPycVJDV3qGBRzuML
KEGUhfSM6DOCFmwTLMMMGntYPuoIbcfoaz9D+xG4hFVO5gEaLqluj3Zq8GCqp44Z
I7TqZItGTx+wVF3ympK6921LyYhIiC9Qah1u31a5+N4xlifidFmvqkAwud1UO7XL
HQK0GubBhpAGEGcKjUG5Safzmf0vk506nrrEHrNr90/Qb5sJmocgQvq75S3VEDB3
qsxjAx/nD95s0VMTj7jE
=Xgz8
-----END PGP SIGNATURE-----

--nextPart9187770.lI0LbIzmBv--
