Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1ISUW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:22:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52971 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab1ISUWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:22:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, pe1dnn@amsat.org
Subject: Re: [PATCH 3/3] staging: wlags49_h2: Declare support for WEXT 21
In-Reply-To: Your message of "Mon, 19 Sep 2011 21:08:16 BST."
             <1316462896-17846-4-git-send-email-kilroyd@googlemail.com>
From: Valdis.Kletnieks@vt.edu
References: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>
            <1316462896-17846-4-git-send-email-kilroyd@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316463771_2864P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Sep 2011 16:22:51 -0400
Message-ID: <15411.1316463771@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E77A49C.006D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316463771_2864P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Sep 2011 21:08:16 BST, David Kilroy said:
> There may be a few areas where we don't actually support WE21,
> but by doing this it will make it easier to find those places.

I'll bite - what happens when we find such a place?  Kernel fails to build, or
user has a suboptimal usage experience, or?

What are the expected chances that sticking this in linux-next for a cycle will
result in most/all of the places being found before this all appears in an
official release?  I'm thinking this should probably go in linux-next right after
the next merge window closes, to maximize the chances we'll shake it
all out during almost 2 cycles before it hits the streets. (And yes, I know
it's a staging/ driver - if somebody else says "one cycle is more than enough"
I'm OK with that too...)


--==_Exmh_1316463771_2864P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOd6SbcC3lWbTT17ARAhPqAJ4h3BeszLrOe5Rycvp79VtNIqLkWgCeOsa4
WQTf/TH+OEA6hXX8Sa6zj1o=
=zn4R
-----END PGP SIGNATURE-----

--==_Exmh_1316463771_2864P--

