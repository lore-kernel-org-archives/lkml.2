Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0CXASN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:18:13 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:24337 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752200Ab0CXASL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:18:11 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: MXxW.hsVM1nfPVCzTnybBYfwwpsy52zSYC.kC1H5gP8PeMj5iBD66SmGb3tuI2yhzrE86mGFoOlD4BcyigLeOgRljZdDf0FTUSWOzYEymjCCCfy5on2bjQS.MZI16svkoghy0vtiFNdlByna3JiKBVEhFTLgBA93nLOP_QqVxIDXMOB9r05ZRiWHi40vwvX6Iz.u6q.y.J5rxOmCViHYCGd.LCyAeFY0fvpQvl9Tyzg2bnStkUpBe_uOHkk65TVQPZmYEzHWpDDNXwRr820B9sGtL7442F3y6qQE9HAZxd3y5fcvP70nUrCj7DHIW9FM23WBMeJSLxNXBQLvcDwQ
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BA95A1A.6020003@schaufler-ca.com>
Date: Tue, 23 Mar 2010 17:17:30 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: zhou peng <ailvpeng25@gmail.com>
CC: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: About ACL for IPC Object
References: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com>	 <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com>	 <4B57C3C3.9010606@schaufler-ca.com> <6fb445941003230201r656d0363k6ed6853c3edc826b@mail.gmail.com>
In-Reply-To: <6fb445941003230201r656d0363k6ed6853c3edc826b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zhou peng wrote:
> Hi,
>
> I have added ACL support to POSIX msg queue on linux kernel 2.6.32.
> Casey Schaufler, would you or anyone like review the patch for me please?
>   

I didn't see anything horribly wrong, but I have not tested it.
Christoph's comments should be heeded.

> The patch is attached.
>   

Please include patches inline. It is much easier to make specific
comments that way and it is The Way We Do Things.

> Best,
>
> 2010/1/21 Casey Schaufler <casey@schaufler-ca.com>:
>   
>> zhou peng wrote:
>>     
>>> Hi all,
>>>
>>> There are ACL in file system, but why there are no ACL implementation
>>> in IPC object, eg. shm, message queue, FIFO?
>>>
>>>       
>> Most people haven't noticed that IPC objects are even there, much less
>> that they have mode bits and not ACLs. Even when we were doing security
>> evaluations on Unix boxes in the 1990's they were considered insufficiently
>> interesting to justify the additional work to do ACLs.
>>
>> If you really want ACLs on IPC objects it would make a dandy little
>> project for a summer. I would be happy to review patches.
>>
>>     
>>> Is there any fine grained granting in ipc object just like in file object?
>>>
>>>       
>> As Stephen Smalley points out, you can do it with SELinux, although
>> that it rather like driving a thumbtack with a bulldozer.
>>
>>     
>>> Thanks,
>>> Best
>>>
>>> --
>>> zhoupeng
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>
>>>       
>>     
>
>
>
>   

