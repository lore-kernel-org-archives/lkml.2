Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1ATQ6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:58:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab1ATQ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:58:12 -0500
Date: Thu, 20 Jan 2011 17:57:34 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] khugepaged crashes on x86_32
Message-ID: <20110120165734.GI21494@random.random>
References: <1295542013.12215.2755.camel@gandalf.stny.rr.com>
 <1295542365.12215.2762.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295542365.12215.2762.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Thu, Jan 20, 2011 at 11:52:45AM -0500, Steven Rostedt wrote:
> On Thu, 2011-01-20 at 11:46 -0500, Steven Rostedt wrote:
> 
> > I hit this bug with both v2.6.38-rc1 and with
> > 
> > HEAD == 12fcdba1b7ae8b25696433f420b775aeb556d89b
> 
> Note, this is not fully reproducible at every boot. To test manually, I
> had to boot up a couple of times to trigger it. But it never took more
> than 5 boots to do so. I test by just booting up and shutting down, it
> may trigger with some use as well, but I did not try that.

There was a highpte mistake in khugepaged that only affected 32bit
with HIGHPTE enabled so it wasn't noticed yet. Fix pointed out by
Minchan is queued in -mm (Johannes's submit).
