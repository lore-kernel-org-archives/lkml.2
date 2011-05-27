Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1E0O3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:29:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36819 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1E0O3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:29:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Keith Curtis <keithcu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Zero bugs (was Re: (Short?) merge window reminder)
In-Reply-To: Your message of "Thu, 26 May 2011 22:44:24 PDT."
             <BANLkTinj1M_VSuvw1Sct8a6TLkUrEP_4uQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <BANLkTinbrtzY66p+1NALP8BDfjXLx=Qp-A@mail.gmail.com> <4DDD0E5F.5080105@panasas.com> <BANLkTi=FAwzW+qR+Cbwmor90pgbgzfuw-g@mail.gmail.com> <4DDE81F4.8060800@panasas.com>
            <BANLkTinj1M_VSuvw1Sct8a6TLkUrEP_4uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306506572_2736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 27 May 2011 10:29:32 -0400
Message-ID: <4265.1306506572@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4DDFB54D.0181,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306506572_2736P
Content-Type: text/plain; charset=us-ascii

On Thu, 26 May 2011 22:44:24 PDT, Keith Curtis said:

> However, it is common in companies to make an effort to get towards
> zero bugs. Zero bugs is impossible, and that is a philosophical
> discussion. If you look through your current list of bugs, nearly
> every one looks scary to me and important to someone. You currently
> have 2,800 active bugs (http://bit.ly/LinuxBugs) The last time I
> looked, I found the median age was 10 months. In general, bugs should
> be fixed in the next release and so therefore 3 months.

You may want to look at what percentage of those bugs were reported on
one hardware platform by one reporter, and the reporter has since evaporated.

I myself started a thread back on April 26 regarding a wonky PS2->USB adapter.
Within 24 hours I had a bunch of good suggestions for further debugging, none
of which I've had a chance to actually follow up on (Hmm.. Monday is a holiday
but nobody will be in the office, maybe I'll have a chance to get in the 4-5
reboots it will take.. :)  So if I had opened a bug, how old is it, and who's fault
is it that it's that old?

> Hitting zero, even for a minute, could be a newsworthy event, as another way
> Linux is better than the others. It also shows leadership to user mode.

Never happen, as at least one of those 2,800 bugs will involve testing a fix on
hardware the reporter no longer has, or the reporter is no longer available, or
similar issues.

You also need to look at the *severity* of the bugs - my USB issue merely
causes me literally 5 second's inconvenience every morning (part of why I
haven't chased it further - it's hard to justify spending 45 minutes fixing a
5-second issue).  If the reporter can't be bothered to help, what are we
supposed to do?  Then there's the oops and panic reports that should count for
a lot more.   How severe are most of those 2,800 bugs?

Probably a lot more productive than "zero bugs" would be "swat the top 10
entries in the kerneloops database", as we know by measurement that they're
both pervasive and high-impact.



--==_Exmh_1306506572_2736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN37VMcC3lWbTT17ARAquuAKDnK56B30s4NtwB0e+dsVPjlIet2wCg+LfK
NbONx9snibaMrTm1LmHFiRU=
=Up17
-----END PGP SIGNATURE-----

--==_Exmh_1306506572_2736P--

