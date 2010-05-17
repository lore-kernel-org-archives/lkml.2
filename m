Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab0EQDcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 23:32:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36061 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab0EQDct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 23:32:49 -0400
Date: Mon, 17 May 2010 13:32:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: linux-next: build failure after merge of the backlight tree
Message-Id: <20100517133239.8a30df8e.sfr@canb.auug.org.au>
In-Reply-To: <20100510124304.2249532c.sfr@canb.auug.org.au>
References: <20100510124304.2249532c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_May_2010_13_32_39_+1000_L0PtpMCrg.seHt/f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_May_2010_13_32_39_+1000_L0PtpMCrg.seHt/f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Mon, 10 May 2010 12:43:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the backlight tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/video/backlight/adp8860_bl.c: In function 'adp8860_led_probe':
> drivers/video/backlight/adp8860_bl.c:215: error: implicit declaration of =
function 'kzalloc'
> drivers/video/backlight/adp8860_bl.c:215: warning: assignment makes point=
er from integer without a cast
> drivers/video/backlight/adp8860_bl.c:285: error: implicit declaration of =
function 'kfree'
> drivers/video/backlight/adp8860_bl.c: In function 'adp8860_probe':
> drivers/video/backlight/adp8860_bl.c:673: warning: assignment makes point=
er from integer without a cast
> drivers/video/backlight/adp8860_bl.c:689: error: too few arguments to fun=
ction 'backlight_device_register'
>=20
> Caused by commit 6f1a02240dba279a389fd4a4138445bd3f13f67f ("backlight:
> new driver for the ADP8860 backlight parts").  Use of kzalloc or kfree
> requires including linux/slab.h (see Rule 1 in
> Documentation/SubmitChecklist) and the prototype of
> backlight_device_register changed before v2.6.34-rc2.

I am still getting these build failures ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__17_May_2010_13_32_39_+1000_L0PtpMCrg.seHt/f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvwuNcACgkQjjKRsyhoI8xxhQCfbDXhOp/R078FVfaLUYmqaFUc
JosAoLZMlNpAW0LtW/nA8EYdCgkkuR5w
=/pVg
-----END PGP SIGNATURE-----

--Signature=_Mon__17_May_2010_13_32_39_+1000_L0PtpMCrg.seHt/f--
