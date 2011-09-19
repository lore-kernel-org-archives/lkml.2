Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab1ISSkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:40:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53838 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab1ISSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:40:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: martin f krafft <madduck@madduck.net>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Abysmal I/O scheduling with dm-crypt
In-Reply-To: Your message of "Tue, 30 Aug 2011 09:14:07 +0200."
             <20110830071407.GA8165@albatross.gern.madduck.net>
From: Valdis.Kletnieks@vt.edu
References: <20110830071407.GA8165@albatross.gern.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316457549_2864P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Sep 2011 14:39:09 -0400
Message-ID: <10932.1316457549@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E778C4E.00AA,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316457549_2864P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Aug 2011 09:14:07 +0200, martin f krafft said:
> I am using encrypted filesystems (dm-crypt) and the 3.0.0 kernel.
> Underneath might be a RAID1 or a fast SSD. On top is usually LVM
> with a few LVs holding the system.
> 
> Whenever an I/O-intensive task starts, such as:

> the system becomes unusable for several seconds at a time, at least
> once or twice per minute.

Sorry for the late reply - I've seen similar on my laptop.  However, I haven't
dug further into it, because the use case that causes the most pain is backing
up the laptop to a LUKS partition on an external USB drive - and I usually
start that and go to bed so it's not-a-problem.   Also, it only wedges up
those processes that actually try to do disk I/O - which means that all
the terminal windows that are running SSH to various servers don't
usually take a hit and things don't get "unusable" in the sense of "totally
weged and locked up".

But I can at least confirm you're not hallucinating. :)



--==_Exmh_1316457549_2864P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOd4xNcC3lWbTT17ARAltXAKCl6CMCqpDfS1h9ZZX6fwXd6/f/UACdG7BJ
CQi5N7Em9oDr44UbAi7EHD8=
=xSLk
-----END PGP SIGNATURE-----

--==_Exmh_1316457549_2864P--

