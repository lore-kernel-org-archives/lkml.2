Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1DSBGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:06:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1DSBGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:06:36 -0400
Message-ID: <4DACE085.9070202@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 09:08:21 +0800
From: liubo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Trace: add __print_symbolic_u64 to avoid warnings on
 32bit machine
References: <4D9573DB.4010009@cn.fujitsu.com>	 <1301665762.2160.22.camel@gandalf.stny.rr.com>	 <4D9C2FF6.7090607@cn.fujitsu.com> <1303150309.7181.51.camel@gandalf.stny.rr.com>
In-Reply-To: <1303150309.7181.51.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-19 09:07:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-19 09:07:09,
	Serialize complete at 2011-04-19 09:07:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 02:11 AM, Steven Rostedt wrote:
> On Wed, 2011-04-06 at 17:18 +0800, liubo wrote:
>> Btrfs has some "ULL" macros, and when these macros are passed to tracepoints'
>> __print_symbolic(), there will be 64->32 truncate WARNINGS during compiling
>> on 32bit box.
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  include/linux/ftrace_event.h |   12 ++++++++++++
>>  include/trace/events/btrfs.h |    4 ++--
>>  include/trace/ftrace.h       |   13 +++++++++++++
>>  kernel/trace/trace_output.c  |   27 +++++++++++++++++++++++++++
>>  4 files changed, 54 insertions(+), 2 deletions(-)
> 
> Could you break this up into two patches. One that touches the ftrace
> core, and one that updates btrfs.
> 

Sure, I'll break it and resend soon.  Thanks for the reply.

thanks,
liubo

> Thanks,
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

