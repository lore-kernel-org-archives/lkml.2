Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1ASP1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:27:23 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:40321 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab1ASP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:27:20 -0500
Message-ID: <4D3702D5.5050502@oldelvet.org.uk>
Date: Wed, 19 Jan 2011 15:27:17 +0000
From: Richard Mortimer <richm@oldelvet.org.uk>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rostedt@goodmis.org, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com, mathieu.desnoyers@efficios.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
References: <1295273486.16479.15.camel@gandalf.stny.rr.com>	<20110117.213448.226787087.davem@davemloft.net>	<20110117.220039.71097651.davem@davemloft.net> <20110117.220857.104046847.davem@davemloft.net>
In-Reply-To: <20110117.220857.104046847.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/01/2011 06:08, David Miller wrote:
> From: David Miller<davem@davemloft.net>
> Date: Mon, 17 Jan 2011 22:00:39 -0800 (PST)
>
>> ftrace: Remove unnecessary alignment tag from ftrace_event_call.
>>
>> It's completely unnecessary and causes problems on platforms
>> where this tag down-aligns the structure's alignment.
>>
>> Signed-off-by: David S. Miller<davem@davemloft.net>
>   ...
>
> Ok, unless we can explain why these alignments are needed at all, we
> should kill all of them:
>
> --------------------
> tracing: Remove unnecessary __aligned__(4) tag from trace data.
>
> It's completely unnecessary and causes problems on platforms
> where this tag down-aligns the structure's alignment.
>
> Signed-off-by: David S. Miller<davem@davemloft.net>
>

For reference my build with the above patch completed last night. That 
does boot on my sparc64 Sun Fire V120 so at the very least the 
relocation issues go away.

The machine wasn't very happy and networking/nfs was a little upset but 
I'll wait until the patchset is more refined before investigating 
further and trying to work out if it is related or not.

Regards

Richard
