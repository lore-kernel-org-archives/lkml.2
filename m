Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0D0NlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:41:16 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34719 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0D0NlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:41:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Constantine Shulyupin <const@linuxdriver.co.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Need advice on updating the Linux kernel map
In-Reply-To: Your message of "Sun, 25 Apr 2010 02:02:29 +0300."
             <t2w8aa6b0651004241602i50449643lc05dcf834a80b344@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <t2w8aa6b0651004241602i50449643lc05dcf834a80b344@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272375671_4032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Apr 2010 09:41:11 -0400
Message-ID: <5312.1272375671@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4BD6E978.0097,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272375671_4032P
Content-Type: text/plain; charset=us-ascii

On Sun, 25 Apr 2010 02:02:29 +0300, Constantine Shulyupin said:
> I was wondering if you could help me. I've recently resumed work on
> the map of the Linux kernel - http://www.makelinux.net/kernel_map in
> order to make it more up-to-date and to improve it. Please let me know
> how I can update the map, as it would help me a lot.

A few quick comments:

1) Can we do better than an OSI 7-layer burrito? ;)  As it stands, doing it
that way creates a lot of things that look like layering violations.  For
instance, "Device Model" is up on "virtual", when it actually gets *used*
several levels further down.  And you have a *lot* of vertical lines that
cross a whole bunch of levels.  You would probably be served much better
by letting each column be a lot wider, and maybe only 4 levels high (you
can probably squish virtual/bridges/logical into one wider level).

1b) Much of the I/O column should be one wide section across the bottom of
disk/network/user peripherals, and the 'system run' box should be in some
other column(s).

2) Security and debugging seem to be forced in the "user peripherals" column
for no real rational reason.

3) I see no mention of tracing/oprofile/perf.

Hope that helps...

--==_Exmh_1272375671_4032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL1ul3cC3lWbTT17ARArudAKDfB2PxeO+LVIm2UfMZB6+oEfl9EwCgpSIt
hQfxq7soW6TGKqiCJI09Ss8=
=gF81
-----END PGP SIGNATURE-----

--==_Exmh_1272375671_4032P--

