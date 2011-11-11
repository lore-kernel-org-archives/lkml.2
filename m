Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1KKKPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:15:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35252 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1KKKPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:15:16 -0500
Date: Fri, 11 Nov 2011 15:44:19 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING at __ftrace_hash_rec_update()
Message-ID: <20111111101419.GA4603@debian>
References: <20111101141420.GA4918@debian>
 <1320453094.26400.0.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320453094.26400.0.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 08:31:34PM -0400, Steven Rostedt wrote:
> On Tue, 2011-11-01 at 19:45 +0530, Rabin Vincent wrote:
> > On v3.1-7810-g094803e (current linus git), I'm able to trigger the below
> > FTRACE_WARN_ON() by running the following sequence of commands.
> > DYNAMIC_FTRACE is enabled.
> > 
> > ftrace.c:1384:
> > 	if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
> > 		return;
> > 	rec->flags--;
> > 
> 
> Thanks for reporting. Can you try this patch please.

Works for me, thanks.  It needed a ret=0 which I see you've already
added in your official submission.
