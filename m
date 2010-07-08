Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab0GHRfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:35:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab0GHRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:35:38 -0400
Date: Thu, 8 Jul 2010 13:35:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric B Munson <emunson@mgebm.net>,
       akpm@linux-foundation.org, mingo@redhat.com, hugh.dickins@tiscali.co.uk,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       anton@samba.org
Subject: Re: [PATCH] Add trace event for munmap
Message-ID: <20100708173515.GA11652@infradead.org>
References: <1278597931-26855-1-git-send-email-emunson@mgebm.net>
 <1278598955.1900.152.camel@laptop>
 <20100708144407.GA8141@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708144407.GA8141@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 03:44:07PM +0100, Eric B Munson wrote:
> On Thu, 08 Jul 2010, Peter Zijlstra wrote:
> 
> > On Thu, 2010-07-08 at 15:05 +0100, Eric B Munson wrote:
> > > This patch adds a trace event for munmap which will record the starting
> > > address of the unmapped area and the length of the umapped area.  This
> > > event will be used for modeling memory usage.
> > 
> > Does it make sense to couple this with a mmap()/mremap()/brk()
> > tracepoint?
> > 
> 
> We were using the mmap information collected by perf, but I think
> those might also be useful so I will send a followup patch to add
> them.

What kind of infrastructure is perf using for recording
mmap()/mremap()/brk() information?
