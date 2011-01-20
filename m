Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1ATRCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:02:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60574 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1ATRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:02:37 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=chl3Z4zJB8kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=EqTSviML6F0DabhKoVcA:9 a=j5I5MW-zCdVE7WjAJMba_yBC3EQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG] khugepaged crashes on x86_32
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110120165734.GI21494@random.random>
References: <1295542013.12215.2755.camel@gandalf.stny.rr.com>
	 <1295542365.12215.2762.camel@gandalf.stny.rr.com>
	 <20110120165734.GI21494@random.random>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 20 Jan 2011 12:02:35 -0500
Message-ID: <1295542955.12215.2773.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 17:57 +0100, Andrea Arcangeli wrote:
> Hi Steven,
> 
> On Thu, Jan 20, 2011 at 11:52:45AM -0500, Steven Rostedt wrote:
> > On Thu, 2011-01-20 at 11:46 -0500, Steven Rostedt wrote:
> > 
> > > I hit this bug with both v2.6.38-rc1 and with
> > > 
> > > HEAD == 12fcdba1b7ae8b25696433f420b775aeb556d89b
> > 
> > Note, this is not fully reproducible at every boot. To test manually, I
> > had to boot up a couple of times to trigger it. But it never took more
> > than 5 boots to do so. I test by just booting up and shutting down, it
> > may trigger with some use as well, but I did not try that.
> 
> There was a highpte mistake in khugepaged that only affected 32bit
> with HIGHPTE enabled so it wasn't noticed yet. Fix pointed out by
> Minchan is queued in -mm (Johannes's submit).

Thanks for the update :-)

I'll apply this patch and run it through the tests again.

-- Steve


