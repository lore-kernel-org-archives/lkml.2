Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1FBOZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:25:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49080 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FBOZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:25:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Will Drewry <wad@chromium.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] init: add root=PARTUUID=UUID+/-%d support
In-Reply-To: Your message of "Thu, 02 Jun 2011 08:48:16 CDT."
             <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1306957788-12310-1-git-send-email-wad@chromium.org> <BANLkTimi2o4vnSWp5rQGrU3BTSC+YyO0qg@mail.gmail.com>
            <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1307024686_2612P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Jun 2011 10:24:46 -0400
Message-ID: <3887.1307024686@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4DE79D30.017B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1307024686_2612P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Jun 2011 08:48:16 CDT, Will Drewry said:

> Good call=21  I'll take a pass at integrating that. I can see a couple
> different ways of handling the parsing (e.g., when and what does it
> affect).  Do you think it would make sense to keep it isolated to just
> being a PARTUUID subargument or would it make more sense for
> PARTNROFF=3D to be evaluated as a generic root=3D attribute?  I can see=

> benefits to both, but one is considerably more minimal to implement :)
>  =5BMaybe I'll try both and see how they look.=5D

I've seen multi-boot configs that have several disks similarly partitione=
d - a /boot
on /dev/sdN1 and / on /dev/sdN2.  For those configs, being able to say =
=22use
partition 2 of whatever disk you booted=22 would be one less thing you ha=
ve
to worry about getting out of sync.


--==_Exmh_1307024686_2612P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN550ucC3lWbTT17ARAj8WAJ0ZqkmEEKCGbdlstYCtsmR8RiRJmQCg2lH9
EQyjeE+RCNOuGAzbFjZSlZk=
=ZKYf
-----END PGP SIGNATURE-----

--==_Exmh_1307024686_2612P--

