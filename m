Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab0LWGH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 01:07:59 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:35387 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab0LWGH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 01:07:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC -v9 0/4] Lock-less list
In-Reply-To: Your message of "Thu, 23 Dec 2010 13:43:19 +0800."
             <1293083003-19577-1-git-send-email-ying.huang@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1293083003-19577-1-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1293084340_5070P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Dec 2010 01:05:40 -0500
Message-ID: <23265.1293084340@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4D12E6B7.01F2,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1293084340_5070P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Dec 2010 13:43:19 +0800, Huang Ying said:
> Add a lock-less NULL-terminated linked list implementation.  And use
> that in irq_work and replace net/rds/xlist.h.

A quick overview of the code looks mostly sane.  What I don't see is
an explanation of *why* this is being added.  What benefits does it
have over the current code?  Is it faster? Smaller?  Simply getting rid
of near-duplicate versions in rds and irq_work? Something else?



--==_Exmh_1293084340_5070P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNEua0cC3lWbTT17ARAtZbAJ9iSaOEZ9AC+ulqDj7YZCF8PQT87gCfVDuo
hqPU0460RRfni+t2SL2Q99s=
=6vPn
-----END PGP SIGNATURE-----

--==_Exmh_1293084340_5070P--

