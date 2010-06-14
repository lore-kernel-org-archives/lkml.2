Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0FNWxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:53:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:47241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035Ab0FNWxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:53:53 -0400
Message-ID: <4C16B2B1.8010101@kernel.org>
Date: Tue, 15 Jun 2010 00:52:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <20100614145839.8ac7687a.akpm@linux-foundation.org>	 <4C16AA75.8030303@kernel.org>	 <1276554672.3505.199.camel@c-dwalke-linux.qualcomm.com>	 <4C16AE4B.609@kernel.org>	 <1276554931.3505.200.camel@c-dwalke-linux.qualcomm.com>	 <4C16B0CA.9060107@kernel.org> <1276555752.3505.204.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1276555752.3505.204.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 22:52:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 12:49 AM, Daniel Walker wrote:
> On Tue, 2010-06-15 at 00:44 +0200, Tejun Heo wrote:
>> On 06/15/2010 12:35 AM, Daniel Walker wrote:
>>> What is you definition of "concurrency" ? and explain try to explain it
>>> in terms of your patchset.
>>
>> How many workers are concurrently executing?  What else?  Eh... I'll
>> write up another summary tomorrow.  Let's talk it there.
> 
> I'd suggest If you write up another description try to not use the word
> concurrency .. That term can be used for all sorts of things, and it
> doesn't covey enough detail for anyone to know what your implementation
> is actually doing.

So is "manage" and "level of concurrency" is often used to describe
exactly this type of property.  I'll try to be clear.

Thanks.

-- 
tejun
