Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab0EDOX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:23:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49742 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab0EDOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:23:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: git bisect questions...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272983034_3858P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 May 2010 10:23:54 -0400
Message-ID: <6677.1272983034@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4BE02DFC.0278,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272983034_3858P
Content-Type: text/plain; charset=us-ascii

Trying to bisect my way through linux-next to track down a nasty DRM bug that
hoses the nouveau driver, and I have a few questions:

1) I look at 'git bisect visualize', and I see a nice merge point that I
am fairly sure will (a) bisect as good and (b) trim out a *lot* of ancestor
commits in one shot.  If I do a 'git reset --hard <merge commit>', will
that make the next 'git bisect' do what I want?

2) I'm down to the last 100 or so commits, and I have a at least 3 'git
bisect skip' in there already because of a (presumably) unrelated oops.
I'm pretty sure that commit 10fd883ce384706f88554a0b08cc4d63345e7d8b is
the fix - how do I logically move that commit to right after the commit
22dd82a3f5ceef72be19e502418823a2f8801ed0 which introduced the oops, so
I can bisect through the 70 or so commits in between?  I know it involves
"git cherrypick", but have no clue how to do it...


--==_Exmh_1272983034_3858P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL4C36cC3lWbTT17ARAgsEAJ9QsXDL4MBwnx2qah0+3gitjhGg4gCglKxY
6NXYcltUt+holIqmoftfk3o=
=uBOV
-----END PGP SIGNATURE-----

--==_Exmh_1272983034_3858P--

