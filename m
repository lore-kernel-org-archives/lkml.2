Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab0FPVmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:42:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:60620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759621Ab0FPVmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:42:31 -0400
Message-ID: <4C1944EF.6000507@kernel.org>
Date: Wed, 16 Jun 2010 23:41:03 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>	 <4C191BE9.1060400@kernel.org> <1276716999.9309.208.camel@m0nster>	 <4C192B94.9020601@kernel.org> <1276719599.9309.243.camel@m0nster>	 <4C1932FB.3000404@kernel.org> <1276720812.9309.266.camel@m0nster>
In-Reply-To: <1276720812.9309.266.camel@m0nster>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 21:41:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 10:40 PM, Daniel Walker wrote:
>> Because the discussion isn't leading anywhere and I've already thrown
>> almost everything I can think of, so if I haven't convinced you yet
>> there's very low probability that I'll be able to do with further
>> discussion.  So, I duly collected your Nacked-by: on the reason that
>> cmwq doesn't allow setting priorities from userland.
> 
> Ok, and please don't try to summarize why there is a NAK'ed-by, if
> people want to know they can contact me directly or read this thread.

No, Daniel.  You don't get to tell me what I write or not.  If you
don't agree with the summary, feel free to offer a better one and I
would consider to update mine.  I'll provide my summary, arguments and
the link to this discussion when I send a pull request and you'll be
cc'd.  You're free to present your arguments there again if you feel
necessary.

-- 
tejun
