Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2F0Wwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:52:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41319 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2F0Wwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:52:37 -0400
Date: Thu, 28 Jun 2012 08:52:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: linux-next: Tree for Jun 27 (eliminated_printk)
Message-Id: <20120628085226.af0623e39a282192935047c3@canb.auug.org.au>
In-Reply-To: <1340814569.16533.53.camel@joe2Laptop>
References: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
	<4FEB340D.3040908@xenotime.net>
	<1340814569.16533.53.camel@joe2Laptop>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Jun_2012_08_52_26_+1000_vApuu8uZZRvN/DzN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Jun_2012_08_52_26_+1000_vApuu8uZZRvN/DzN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

One for you ...

On Wed, 27 Jun 2012 09:29:29 -0700 Joe Perches <joe@perches.com> wrote:
>
> On Wed, 2012-06-27 at 09:25 -0700, Randy Dunlap wrote:
> >=20
> > on i386:
> >=20
> > drivers/platform/x86/thinkpad_acpi.c: In function 'drv_acpi_handle_init=
':
> > drivers/platform/x86/thinkpad_acpi.c:684:2: error: implicit declaration=
 of function 'eliminated_printk'
> >=20
> > drivers/platform/x86/fujitsu-laptop.c: In function 'call_fext_func':
> > drivers/platform/x86/fujitsu-laptop.c:223:3: error: implicit declaratio=
n of function 'eliminated_printk'
> >=20
> >=20
> > Full randconfig file is attached.
>=20
> Thanks Randy.
>=20
> This patch depends on the first patch in the series
> which hasn't been applied.
>=20
> https://lkml.org/lkml/2012/6/17/229
> https://lkml.org/lkml/2012/6/17/231


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Jun_2012_08_52_26_+1000_vApuu8uZZRvN/DzN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP646qAAoJEECxmPOUX5FE8K0P/jaleQyPd/dizQXnzpHkI+Sb
LMNZ5GOyNskG0tHlLACvYgfyalZRVhID5Fg9iorEPD2lWpgwm6ZyrT1PPZS/cMEL
mehhL0TyncS7RFAVu6S9GcQH1q5qY4PExxVwyCzMm7PmL0iaDOdGuxBaWpY4BFut
LG+3rTUqyw0pFVMX/Ne1YcBQ+gmdO7EJpNwTTsWKl+XJ3m9a43AYY2zONYASMjZt
QclI+qsa2sMyZyyUSTceEafC/kkZRlH1TpcaStzIelq23eCQvRHmX5KStRIQYQ3/
P4KCchro2NhqsffHFvlNDCD8bMXSEmaptMBDGIqz2PGsLcGLfZ2inRVghD9Gizk9
vMpNVbrm/Qz6RkfzxMEz7PhDuGJ9bh3nc4ZcfkVH3sTav2KPKbxFGuj09K2nrRwK
wMISVopVAJkAyV1nkHKmLr4Fb5z43QWBxvkDtrxsBpV7k9OcdX1Qudm/zkdPAVKj
Iv9i2kHBW2AicZzDax6IwAiFhhCKMmzRODRARCcxkHezUgJujV+xQ8HfzSXJP/QB
g+5AA2dXf5q0PxcmdVDW59qIAAcMYMce2Y/Wk1O7hvrFXFMS2/do0anbrNProq1x
AwSnc90sq46/0zpyp9uqRIsrWhP1mcmjdZwOPt2LktpclGkHWvhA8XAYf/oGIOnF
G4iMFhcIsimgZV6HqYAI
=1tlq
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jun_2012_08_52_26_+1000_vApuu8uZZRvN/DzN--
