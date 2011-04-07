Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1DGCOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:14:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:19967 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab1DGCOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:14:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,314,1299484800"; 
   d="scan'208";a="906546177"
Message-ID: <4D9D1DF0.6030704@intel.com>
Date: Thu, 07 Apr 2011 10:14:08 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: huang ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "lenb@kernel.org" <lenb@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: About lock-less data structure patches
References: <20110329202649.137a8a18.akpm@linux-foundation.org> <20110330133411.GA11101@Krystal> <BLU0-SMTP52616BFA7ABB7E8E73E8396BC0@phx.gbl> <4D93DB49.3060205@intel.com> <20110401213748.GA26543@Krystal> <4D96AEAE.2010800@intel.com> <20110404155328.GA13390@Krystal> <BANLkTin3XpOnnqWcu-bsUCJ_6JaYcBkJkg@mail.gmail.com> <20110405044227.GA20013@Krystal> <BANLkTinLH=s419RVQXSUTjBSdH0XjdpZWg@mail.gmail.com> <20110406014824.GB32321@Krystal>
In-Reply-To: <20110406014824.GB32321@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 09:48 AM, Mathieu Desnoyers wrote:
> * huang ying (huang.ying.caritas@gmail.com) wrote:
[snip]
>>>>
>>>> OK.  I will change the comments, adding these semantics explanation.
>>>> The user should be warned :)
>>>
>>> Yes, that makes sense. After this generalization step, if you're ok with
>>> this, we could aim at moving the implementation from a stack to a queue
>>> and provide fifo semantic rather than lifo, so that other users (e.g.
>>> call_rcu in the kernel) can start benefiting from it.
>>
>> I think that is good to move from stack to queue.
>>
>> I will send out changed lock-less data structure patchset soon.  And
>> we can continue to work on the new lock-less queue at the same time.
> 
> Sounds like a very good plan! Thanks!

Maybe you can send out your lock-less queue patches, so we can work on that.

Best Regards,
Huang Ying
