Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab1CQVvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:51:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab1CQVvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:51:13 -0400
Date: Thu, 17 Mar 2011 17:51:04 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: make checkpatch warn about memset with swapped arguments.
Message-ID: <20110317215104.GA12157@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110317045209.GA18656@redhat.com>
 <20110317193645.GD14675@home.goodmis.org>
 <20110317200215.GA4084@redhat.com>
 <1300394224.16880.518.camel@gandalf.stny.rr.com>
 <20110317141108.52697d81.akpm@linux-foundation.org>
 <1300397896.16880.584.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300397896.16880.584.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:38:16PM -0400, Steven Rostedt wrote:

 > > Maybe it's just me, but I think it would be better to use bzero() for
 > > this operation - it's more readable and it can't be screwed up.  Then
 > > checkpatch checks for memset(xxx, 0, xxx) and for memset(xxx, xxx, 0)
 > > and says "hey, use bzero".  
 > 
 > Honestly, I've never had the issues with memset. Maybe back in college.
 > But heh, whatever.

You're smarter than the average bear.

Given how often this bug turns up in both userspace and kernelspace,
it's a landmine waiting for someone to step on.

	Dave
 
