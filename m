Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0CVOvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:51:07 -0400
Received: from xenotime.net ([72.52.64.118]:56051 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753220Ab0CVOvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:51:05 -0400
Message-ID: <4BA783D5.3050205@xenotime.net>
Date: Mon, 22 Mar 2010 07:51:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 9/10] Uprobes Documentation patch
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6> <20100320142638.11427.49335.sendpatchset@localhost6.localdomain6> <4BA6DD35.40600@xenotime.net> <20100322053418.GB30463@linux.vnet.ibm.com>
In-Reply-To: <20100322053418.GB30463@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/10 22:34, Srikar Dronamraju wrote:
> Thanks for the review, 
> The next version of the patchset will address your comments.
> 
>>> +
>>> +This user-bkpt based version of Uprobes is implemented on the following
>>
>> s/bkpt/breakpoint/
>>
> 
> Your comment however made me realize that I had used user-bkpt here
> rather than user_bkpt.
> 
> user_bkpt is a layer that provides breakpoint insertion and removal. 
> I wanted to mention that uprobes depends on user_bkpt layer.
> I think "This user_bkpt based version" is probably better than
> "This user-breakpoint based version"

I see.  Sure, that's fine.

-- 
~Randy
