Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0FDF7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:59:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62457 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab0FDF7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:59:23 -0400
Message-ID: <4C0896C9.1000708@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 14:01:45 +0800
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
References: <1275594103.15884.35.camel@gandalf.stny.rr.com>	 <4C08594E.2000703@cn.fujitsu.com> <1275624897.15884.74.camel@gandalf.stny.rr.com>
In-Reply-To: <1275624897.15884.74.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2010-06-04 at 09:39 +0800, Li Zefan wrote:
> 
>> This patch seriously conflicts with my patch that extracts common fields
>> from every trace event to a global list, which is already in your perf/core2
>> branch. Should I rebase and resend it?
> 
> I pushed out a conflict resolution of pulling tip/perf/urgent-2 into
> tip/perf/core-2 (and pushing that as tip/perf/core-4).
> 
> I did change a bit.
> 

The code looks ok.

But we can simplify the seqfile code based on the fact that the common
fields has been in a global list. I can make an incremental patch.
