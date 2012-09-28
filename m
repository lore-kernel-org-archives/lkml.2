Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2I1KBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:01:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56772 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2I1KBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:01:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5934470"
Message-ID: <50657611.3070801@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 18:04:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] workqueue: remove WORKER_PREP from rescuer
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com> <1348680043-5077-4-git-send-email-laijs@cn.fujitsu.com> <20120926182402.GD12544@google.com>
In-Reply-To: <20120926182402.GD12544@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 18:01:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 18:01:55,
	Serialize complete at 2012/09/28 18:01:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 02:24 AM, Tejun Heo wrote:
> On Thu, Sep 27, 2012 at 01:20:34AM +0800, Lai Jiangshan wrote:
>> There is no reason to use WORKER_PREP, remove it from rescuer.
>>
>> And there is no reason to set it so early in alloc_worker(),
>> move "worker->flags = WORKER_PREP" to start_worker().
> 
> Merge this with the patch to add RESCUER to NOT_RUNNING?
> 

Hi, Tejun:

Don't merge. the change log is not good.
I should list all the purposes of WORKER_PREP(I did it in my note),
and then we can claim that we don't need to add WORKER_PREP show early.

These two patches do different things.

Thanks,
Lai
