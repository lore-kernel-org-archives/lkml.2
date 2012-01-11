Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2AKR62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:58:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64940 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab2AKR6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:58:25 -0500
Date: Wed, 11 Jan 2012 09:58:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: axboe@kernel.dk, mingo@redhat.com, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com
Subject: Re: [PATCH 6/9] block: add block_touch_buffer tracepoint
Message-ID: <20120111175820.GI26832@google.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-7-git-send-email-tj@kernel.org>
 <1326303721.7642.59.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326303721.7642.59.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:42:01PM -0500, Steven Rostedt wrote:
> On Tue, 2012-01-10 at 10:28 -0800, Tejun Heo wrote:
> >  
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/block.h>
> > diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> > index 458f497..245caed 100644
> > --- a/include/linux/buffer_head.h
> > +++ b/include/linux/buffer_head.h
> > @@ -13,6 +13,7 @@
> >  #include <linux/pagemap.h>
> >  #include <linux/wait.h>
> >  #include <linux/atomic.h>
> > +#include <trace/events/block.h>
> 
> trace/events/x.h in a header can cause issue if this header is ever
> included in another trace/events/x.h header. I think I'll need to write
> a patch that allows this, but it wont be pretty.

Hmmm... I see.  I'll make touch_buffer() a function.

Thanks.

-- 
tejun
