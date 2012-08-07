Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2HGOvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:51:00 -0400
Received: from nm22-vm4.bullet.mail.sg3.yahoo.com ([106.10.151.51]:40419 "HELO
	nm22-vm4.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754488Ab2HGOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:50:58 -0400
X-Yahoo-Newman-Id: 35121.21787.bm@smtp205.mail.sg3.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: u.K9Q.cVM1me3_rO4WgYzxjNfh3Pgt0V2Xjbcdvt_qpPQIJ
 dueiOlQJxZsjnnN47aNxvl1brOrMx7MyigaUzUmC8hQORtOlU5ugnsATFoT0
 8otzFB0B_clAYYlJUlY8eIb0cu_69wEWc6FlYmUG4bfXgF1Yce89dqu4203v
 v6HZJN2Z3bzqY2rF40.LZQfTZuDjEgD1p4U1djv1i.i_krInX2ITRr1IpCrc
 mTvwvmcH3ofDYdlWn.rPsKPNk9wLdBkjVnp0WAFhtn.5iiUhbcUrSoCE.ykc
 eAo4hllWSFcwh2hgF_2b.PeCwfKtxI6MB7Bhcqf.21AWIPzI9djiGrZ0TExo
 P_LAiRAYUuSf4EdLzvoB6qt5NG0.wlr2KyncohH1OYbZP62XmUSgLQe4AFMv
 jE1Hb9m1DwQXDGTUOKNLB_Q--
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Tue, 7 Aug 2012 20:27:38 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: Re: [PATCH] net:appletalk:ddp:fixed coding style issue again
 relating to
Message-ID: <20120807145738.GA5175@debian.Jeff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/ Is putting "rc = put_user(amount, (int __user *)argp);" on the same
/ indentation level as "amount = skb->len - sizeof(struct ddpehdr);"
/ really what you want to do?

No. I was trying to place those lines at one
indentation back from their current position.


Thanks

/Jeffrin.

-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.
