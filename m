Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab1EYQu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:50:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41633 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1EYQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:50:56 -0400
Message-ID: <4DDD335B.8000904@oracle.com>
Date: Wed, 25 May 2011 09:50:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: liubo <liubo2009@cn.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid warnings
 on 32bit machine
References: <4D9573DB.4010009@cn.fujitsu.com>	 <1301665762.2160.22.camel@gandalf.stny.rr.com>	 <4D9C2FF6.7090607@cn.fujitsu.com>	 <1303150309.7181.51.camel@gandalf.stny.rr.com>	 <4DACE6E0.7000507@cn.fujitsu.com> <4DBA8C95.4000300@cn.fujitsu.com>	 <1304264124.25414.1079.camel@gandalf.stny.rr.com>	 <4DDDE9E6.7090303@cn.fujitsu.com>	 <1306326464.1465.85.camel@gandalf.stny.rr.com>	 <20110525091252.8899385e.randy.dunlap@oracle.com> <1306342064.1465.101.camel@gandalf.stny.rr.com>
In-Reply-To: <1306342064.1465.101.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DDD336A.00F1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/11 09:47, Steven Rostedt wrote:
> On Wed, 2011-05-25 at 09:12 -0700, Randy Dunlap wrote:
>>  
>>> But what I sent out previously is not going into 2.6.40 anyway. Ingo
>>> feels that it's too late in the merge window to pull those changes and
>>> wants to wait till the next merge window. Since there's some fixes in
>>> that pull request, I'll need to cherry pick them out and rebase the rest
>>> for the next window.
>>
>> Sorry to hear all of that.  This fix is needed in mainline.
>>
> 
> Hmm, it is a warning fix. Well, I could add this to the cherry picking
> I'm doing (fixes only).

Yes, I know.  And it clutters up a build file with 59 warnings for btrfs.h.  :(

> I'm currently making a fix for a triple fault in the function tracer
> caused by PROVE_RCU causing recursive tracing. When I get this fixed,
> I'll be pushing the "fixes" next.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
