Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab2LTTZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:25:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16831 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LTTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:25:06 -0500
Message-ID: <50D365F2.7070607@oracle.com>
Date: Thu, 20 Dec 2012 14:24:34 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: remove redundant check
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com> <1356030701-16284-23-git-send-email-sasha.levin@oracle.com> <20121220191803.GA14527@htj.dyndns.org>
In-Reply-To: <20121220191803.GA14527@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 02:18 PM, Tejun Heo wrote:
> On Thu, Dec 20, 2012 at 02:11:31PM -0500, Sasha Levin wrote:
>> We already know that 'event' is non-NULL, remove the redundant check.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> 
> I don't know.  I kinda like that test there.  It's not an error path
> and tearing down everything which could have been allocated.  If the
> test not being used is bothering, convert return -ENOMEM to goto fail?

Can't say it's bothering. If you'd prefer to leave it as is I'm okay with
doing that.


Thanks,
Sasha

