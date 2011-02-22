Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab1BVFN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:13:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38900 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab1BVFN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:13:56 -0500
Date: Tue, 22 Feb 2011 16:13:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>
Subject: linux-next: build warnings after merge of the drivers-x86 tree
Message-Id: <20110222161345.c23850ea.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Feb_2011_16_13_45_+1100_IYxQVOf1lGXBvbXo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Feb_2011_16_13_45_+1100_IYxQVOf1lGXBvbXo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

After merging the drivers-x86 tree, today's linux-next build (x86_64
allmodconfig) produced these warning:

drivers/platform/x86/dell-wmi-aio.c:29:1: warning: "pr_fmt" redefined
In file included from include/linux/kernel.h:20,
                 from drivers/platform/x86/dell-wmi-aio.c:19:
include/linux/printk.h:145:1: warning: this is the location of the previous=
 definition
drivers/platform/x86/dell-wmi-aio.c: In function 'dell_wmi_aio_find':
drivers/platform/x86/dell-wmi-aio.c:130: warning: return discards qualifier=
s from pointer target type

Caused by commit 2ef3d3fdc94c0ef481c60b7958785f05a0faf2ec ("Enable Dell
All-In-One volume up/down keys").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Feb_2011_16_13_45_+1100_IYxQVOf1lGXBvbXo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNY0YJAAoJEDMEi1NhKgbsuasH/0M2QZaNCkzjb9OLi4SQa57h
MIIzX12bsYSp+BKWlNdfsVBC8s06qqA8MMo5R/Szx/PBLM9MgdqinZ5gnPH4iLRu
4tAIDyAr4+RMCWylXC1IrWH64gderdBOgwjqERZPSyFZoxkmDdrRh0KqKLVVNC/Q
qsg+LN38MUTGDUcIZGgAnD6vCG9OKmNM6iZMn0UdH5cnnumMAe4GDhG66+DQdzwK
UBp6evuubwy5Wnt+onU1uSDduz4lJOi5yprToWqGQEoDR2k3jelxtu5v5DSJmvcr
LRbJvGTUl5P+77vAy6+3knbvoi4WB6as7/BYNzjcE/PDXNZnZxkY1tARTSoaRp0=
=c5S6
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Feb_2011_16_13_45_+1100_IYxQVOf1lGXBvbXo--
