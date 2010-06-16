Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab0FPUZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:25:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:40687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0FPUZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:25:41 -0400
Message-ID: <4C1932FB.3000404@kernel.org>
Date: Wed, 16 Jun 2010 22:24:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>	 <4C191BE9.1060400@kernel.org> <1276716999.9309.208.camel@m0nster>	 <4C192B94.9020601@kernel.org> <1276719599.9309.243.camel@m0nster>
In-Reply-To: <1276719599.9309.243.camel@m0nster>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 20:24:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 10:19 PM, Daniel Walker wrote:
>> I don't have any problem with that.  I would be almost happy to get
>> your NACK.
> 
> Oh yeah? why is that?

Because the discussion isn't leading anywhere and I've already thrown
almost everything I can think of, so if I haven't convinced you yet
there's very low probability that I'll be able to do with further
discussion.  So, I duly collected your Nacked-by: on the reason that
cmwq doesn't allow setting priorities from userland.

Thanks and have a good night.

-- 
tejun
