Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1KOBnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 20:43:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab1KOBnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 20:43:12 -0500
Message-ID: <4EC1C41C.2020603@cn.fujitsu.com>
Date: Tue, 15 Nov 2011 09:45:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Paul Menage <paul@paulmenage.org>, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH] Replace Paul Menage with Tejun Heo as cgroups maintainer
References: <1321320612-57855-1-git-send-email-paul@paulmenage.org> <20111115013655.GH30922@google.com>
In-Reply-To: <20111115013655.GH30922@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-15 09:43:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-15 09:43:04,
	Serialize complete at 2011-11-15 09:43:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(also cc Paul Turner)

09:36, Tejun Heo wrote:
> (cc'ing akpm, Ingo and Frederic)
> 
> On Mon, Nov 14, 2011 at 05:30:12PM -0800, Paul Menage wrote:
>> As is probably painfully obvious, I don't have time to be a cgroups
>> maintainer.  Rather than have me continue to hope that I'll magically
>> find more spare time, instead Tejun has kindly agreed to take over the
>> role, along with Li Zefan.
>>
>> Signed-off-by: Paul Menage <paul@paulmenage.org>
>> ---
>>
>> Tejun, Li - can I get your acks before I send this on to mainline?
> 
> Sure,
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> I'll set up cgroup korg git tree and do standard for-next / for-fixes

Thanks. I would have done this if not having restored my kernel.org
account. :)

> branch management.  I won't be committing patches unless co-acked by
> Li Zefan.
> 
> If anyone objects / has better ideas, please speak up.
> 
> Thank you.
> 
>>  MAINTAINERS |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 4808256..055b7f6 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1926,7 +1926,7 @@ S:	Maintained
>>  F:	drivers/connector/
>>  
>>  CONTROL GROUPS (CGROUPS)
>> -M:	Paul Menage <paul@paulmenage.org>
>> +M:	Tejun Heo <tj@kernel.org>
>>  M:	Li Zefan <lizf@cn.fujitsu.com>
>>  L:	containers@lists.linux-foundation.org
>>  S:	Maintained
>> -- 
>> 1.7.5.4
>>
> 
