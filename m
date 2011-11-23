Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab1KWQAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:00:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53539 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab1KWP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:59:59 -0500
Date: Wed, 23 Nov 2011 07:59:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace_event_filter: factorize filter creation
Message-ID: <20111123155952.GA25780@google.com>
References: <20111123014603.GA19630@google.com>
 <20111123020016.GB19630@google.com>
 <1322061561.20742.53.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322061561.20742.53.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 23, 2011 at 10:19:21AM -0500, Steven Rostedt wrote:
> For such a change, I would have liked to see more deletions than
> insertions. Although, if it removes duplicate code, I'm not against such
> a change.

Yeah, certainly.  If you count out the function comments, it reduces
~30 lines of code.  I was trying to add another user and with one more
user, the stats become more attractive.

> I'll look at this more when I get some more time. But just in
> case I forget about it (because I wont look at it before my turkey
> dinner tomorrow, and will most likely forget about it come next Monday),
> please feel free to ping me again next week.

Will do so.

Thank you.

-- 
tejun
