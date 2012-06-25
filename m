Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2FYLTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:19:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60274 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2FYLTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:19:39 -0400
Date: Mon, 25 Jun 2012 19:19:29 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
Message-ID: <20120625111929.GC12148@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com>
 <4FE834D9.8070903@jp.fujitsu.com>
 <20120625104357.GB12148@kernel>
 <20120625110926.GJ19805@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625110926.GJ19805@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 01:09:26PM +0200, Michal Hocko wrote:
>On Mon 25-06-12 18:43:57, Wanpeng Li wrote:
>> On Mon, Jun 25, 2012 at 06:52:25PM +0900, Kamezawa Hiroyuki wrote:
>> >(2012/06/25 17:44), Wanpeng Li wrote:
>> >> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> >> 
>> >> Optimize memcg_get_hierarchical_limit to save cpu cycle.
>> >> 
>> >> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>> >
>> >I can't understand the benefit of this patch to the real world...
>> >
>> >So, if you wrote the patch description as "clean up" rather than optimize,
>> >ok, I'll agree.
>> OK, I will change to "Cleanup". Thank you Kame.
>
>Does this really clean something up?

OK, just drop it and resend the patch. Hopefully, you can applied! :-)

Best Regards,
Wanpeng Li

>-- 
>Michal Hocko
>SUSE Labs
>SUSE LINUX s.r.o.
>Lihovarska 1060/12
>190 00 Praha 9    
>Czech Republic
