Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0JPWcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 18:32:45 -0400
Received: from mx1.melware.net ([78.47.171.162]:58480 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab0JPWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 18:32:44 -0400
Date: Sun, 17 Oct 2010 00:32:43 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Tejun Heo <tj@kernel.org>
cc: Karsten Keil <isdn@linux-pingi.de>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2.6.36-rc7] isdn/eicon: don't call flush_scheduled_work()
 from diva_os_remove_soft_isr()
In-Reply-To: <4CB9A478.5040501@kernel.org>
Message-ID: <alpine.DEB.2.00.1010170031270.29490@justus.melware.de>
References: <4CB84FAF.5080608@kernel.org> <alpine.DEB.2.00.1010161441040.27329@justus.melware.de> <4CB9A478.5040501@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010, Tejun Heo wrote:
> Hello,
>
> On 10/16/2010 02:42 PM, Armin Schindler wrote:
>> On Fri, 15 Oct 2010, Tejun Heo wrote:
>>> diva doesn't use workqueue and there is no reason to flush the system
>>> workqueue from diva_os_remove_soft_isr().  Remove it.
>>>
>>> This is to prepare for the deprecation and removal of
>>> flush_scheduled_work().
>>
>> This is a leftover. Thanks.
>>
>> Acked-by: Armin Schindler <armin@melware.de>
>
> Thank you.  Are you gonna route this patch or shall I push it through
> wq tree?

It's your patch ;-)

Armin

