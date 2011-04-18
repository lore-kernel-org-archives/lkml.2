Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab1DRSLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:11:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1DRSLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:11:51 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=nefNgFSqvmAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=O33rior8q98lRmrFKBAA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Trace: add __print_symbolic_u64 to avoid warnings on
 32bit machine
From: Steven Rostedt <rostedt@goodmis.org>
To: liubo <liubo2009@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
In-Reply-To: <4D9C2FF6.7090607@cn.fujitsu.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	 <1301665762.2160.22.camel@gandalf.stny.rr.com>
	 <4D9C2FF6.7090607@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 14:11:49 -0400
Message-ID: <1303150309.7181.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 17:18 +0800, liubo wrote:
> Btrfs has some "ULL" macros, and when these macros are passed to tracepoints'
> __print_symbolic(), there will be 64->32 truncate WARNINGS during compiling
> on 32bit box.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  include/linux/ftrace_event.h |   12 ++++++++++++
>  include/trace/events/btrfs.h |    4 ++--
>  include/trace/ftrace.h       |   13 +++++++++++++
>  kernel/trace/trace_output.c  |   27 +++++++++++++++++++++++++++
>  4 files changed, 54 insertions(+), 2 deletions(-)

Could you break this up into two patches. One that touches the ftrace
core, and one that updates btrfs.

Thanks,

-- Steve


