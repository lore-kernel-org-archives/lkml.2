Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738Ab2COWLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:11:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35266 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab2COWL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:11:29 -0400
Date: Fri, 16 Mar 2012 09:11:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, linux-arch@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 21/38] Disintegrate asm/system.h for PowerPC [ver #3]
Message-Id: <20120316091121.1a204465647258dddc3bd89d@canb.auug.org.au>
In-Reply-To: <20120315205831.28759.61679.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
	<20120315205831.28759.61679.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_09_11_21_+1100_WMGSzLZFfEeAgF2D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_09_11_21_+1100_WMGSzLZFfEeAgF2D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 15 Mar 2012 20:58:32 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
>  arch/powerpc/platforms/iseries/dt.c               |    1=20
>  arch/powerpc/platforms/iseries/lpevents.c         |    1=20
>  arch/powerpc/platforms/iseries/setup.c            |    1=20
>  arch/powerpc/platforms/iseries/smp.c              |    1=20
>  arch/powerpc/platforms/iseries/viopath.c          |    1=20

I don't expect you to change your series (now, anyway), but just a heads
up that all those files have been removed in the powerpc tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Mar_2012_09_11_21_+1100_WMGSzLZFfEeAgF2D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYmkJAAoJEECxmPOUX5FEULUP/1AR0SltRXfg2mLEuZhgz/cc
QaRqQ3PaCIkMI6pO6Ykgib8t69V4pFl/NJn4BTK1TzY/9q0Ljo7Olq6K1ZSQ86zk
8l8Pmx1jsOpFO5vvIcf7bMOiSiu95PNPSurzfulgxzkcXn3eNHO2Egr05pC06mML
ZZHUgsxLA50s0hDuZZ3dHrl3qwiwnCZwe/MSioToya4y06FEB1o0x8Kf5gGXQCT2
wQ9DfrL6JnRMkaRvJQSAtX0MHqoE0wSpuaI6aHQ+cwXud1Vcbs+ui42VoDlwp7Gm
IDfsqx6S7W/7uFKITvYk+OBQc5/OmUftoS5VH1MbReSp0E17QC0DVSAUy860xLZe
IfkfdtRXHqd7XmcbGHniKwi+TaVe8haADMsns/l6PY3IQCTKJ3LlKLmbB58gdJkE
opaT32F0Spb34T6GWXOvFFKcADCJSsL07wES59+DlFnE4S76xOamCNkI/0B80V+c
Fz7s8pCfoWe0+FZYMNt2h269EtrYgAo01ySMpGzn1ajQcf5fmXVS/iINmTn3eTyE
tCAWY/2ttab0bnRy/ZkSZNLEOXnfR/snTQ/gDXmWrtMzsqDEBC/n3dsmOqyhhsuS
DQH+TYf911LdUJVwr8VbG+qHrPXkDeEeW4vso/Ie1MLYRPX9kPhwaP0Ak2qn3vCp
dtCEubzdflNaioMLlC8S
=mdZk
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_09_11_21_+1100_WMGSzLZFfEeAgF2D--
