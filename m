Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1E1WDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 18:03:40 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50143 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1E1WDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 18:03:39 -0400
Date: Sun, 29 May 2011 00:03:25 +0200
From: Florian Mickler <florian@mickler.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Keith Curtis <keithcu@gmail.com>
Subject: Re: Zero bugs (was Re: (Short?) merge window reminder)
Message-ID: <20110529000325.07f5633a@schatten.dmk.lab>
In-Reply-To: <4265.1306506572@turing-police.cc.vt.edu>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
	<BANLkTinbrtzY66p+1NALP8BDfjXLx=Qp-A@mail.gmail.com>
	<4DDD0E5F.5080105@panasas.com>
	<BANLkTi=FAwzW+qR+Cbwmor90pgbgzfuw-g@mail.gmail.com>
	<4DDE81F4.8060800@panasas.com>
	<BANLkTinj1M_VSuvw1Sct8a6TLkUrEP_4uQ@mail.gmail.com>
	<4265.1306506572@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 10:29:32 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Thu, 26 May 2011 22:44:24 PDT, Keith Curtis said:
> 
> > However, it is common in companies to make an effort to get towards
> > zero bugs. Zero bugs is impossible, and that is a philosophical
> > discussion. If you look through your current list of bugs, nearly
> > every one looks scary to me and important to someone. You currently
> > have 2,800 active bugs (http://bit.ly/LinuxBugs) The last time I
> > looked, I found the median age was 10 months. In general, bugs should
> > be fixed in the next release and so therefore 3 months.
> 

Besides the valid points Valdis gave, also many of the bugs (if they
are severe/real world bugs) are already fixed. That is because the
bugzilla is not the only place where bugs are reported and resolved and
only the original submitter and some other people are able to close bugs. 

Most of the development happens on the mailinglist. So this
is also where most of the bugs get solved. 

( Mailinglists also have the advantage of automatically garbage
collecting old bug reports nobody has any interest in solving. This is
a big drawback with bugzilla. If there is too much garbage in the
bugzilla because nobody closes bugs, then developers will not take old
bugzilla reports seriously. )

So if you want to make the bugzilla more useful, just go for it and put
relevant people  on the cc list of ignored bug reports, ping people that have not
answered to a specific question for months (the bugzilla looses
notification mails sometimes).. And if you determine bugs that can be
closed, drop me a line, I will be happy to do that, if it is
appropriate.

Regards,
Flo
