Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818Ab0JSJ2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:28:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:39558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423Ab0JSJ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:28:06 -0400
Message-ID: <4CBD6489.4030307@kernel.org>
Date: Tue, 19 Oct 2010 11:27:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: lkml <linux-kernel@vger.kernel.org>, mst@redhat.com
Subject: Re: [PATCH RFC] workqueue: remove in_workqueue_context()
References: <4C9B497B.4060302@kernel.org> <20100923171019.GD2406@linux.vnet.ibm.com> <4CB869CC.7070800@kernel.org>
In-Reply-To: <4CB869CC.7070800@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 09:27:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2010 04:48 PM, Tejun Heo wrote:
>> I added it for the drivers/vhost changes.  They were using a
>> variant of RCU where executing in workqueue context acted as an RCU
>> read-side critical section and where flushing workqueues acted as
>> an RCU grace period.  The in_workqueue_context() was then passed to
>> rcu_dereference_check() to verify correct usage.
>>
>> But you are right, I don't see it being used any more, though I do still
>> see the big block comment documenting this in drivers/vhost/vhost.h.
>>
>> Michael, what are Tejun and I missing here?
> 
> Ping.  Shall I go forward with this patch?

Applied to wq#for-next.  Scream if this should be reverted.

Thanks.

-- 
tejun
