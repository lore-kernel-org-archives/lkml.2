Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0FVN3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:29:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:39410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0FVN3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:29:21 -0400
Date: Tue, 22 Jun 2010 06:28:39 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH for stable] tracing: Consolidate protection of reader
 access to the ring buffer
Message-ID: <20100622132839.GA18974@suse.de>
References: <1277212983.9181.27.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277212983.9181.27.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 09:23:03AM -0400, Steven Rostedt wrote:
> Greg,
> 
> Johannes has been hitting a bug in 2.6.33 that we believe is fixed with
> the following patch. The bug is hit a few times a week, so it is hard to
> verify. But we are only hitting it with .33 and not .34, and this patch
> looks like it would be the one to fix it.
> 
> Can you apply this patch to the 2.6.33 stable series.

If you are ok with it, I'll apply it as it does look a little "big" for
a stable kernel :)

I'll queue it up later today.

thanks,

greg k-h
