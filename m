Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0FDBg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:36:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56287 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756994Ab0FDBg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:36:58 -0400
Message-ID: <4C08594E.2000703@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 09:39:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH][GIT PULL][v2.6.35] tracing/events: Convert format output
 to seq_file
References: <1275594103.15884.35.camel@gandalf.stny.rr.com>
In-Reply-To: <1275594103.15884.35.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Steven Rostedt (1):
>       tracing/events: Convert format output to seq_file
> 
> ----
>  kernel/trace/trace_events.c |  208 +++++++++++++++++++++++++++++--------------
>  1 files changed, 142 insertions(+), 66 deletions(-)
> ---------------------------
> commit 0953fa1f774105fcd6150282b7b9ea7763090f64
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu Jun 3 15:21:34 2010 -0400
> 
>     tracing/events: Convert format output to seq_file
>     

This patch seriously conflicts with my patch that extracts common fields
from every trace event to a global list, which is already in your perf/core2
branch. Should I rebase and resend it?

