Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2FRNTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:19:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37432 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2FRNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:19:45 -0400
Date: Mon, 18 Jun 2012 21:19:32 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] mm/memcg: add unlikely to mercg->move_charge_at_immigrate
Message-ID: <20120618131918.GA2600@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com>
 <4FDF2890.3020004@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDF2890.3020004@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 05:09:36PM +0400, Glauber Costa wrote:
>On 06/18/2012 05:10 PM, Wanpeng Li wrote:
>>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>
>>move_charge_at_immigrate feature is disabled by default. Charges
>>are moved only when you move mm->owner and it also add additional
>>overhead.
>
>How big is this overhead?
>
>That's hardly a fast path. And if it happens to matter, it will be
>just bigger when you enable it, and the compiler start giving the
>wrong hints to the code.

Thank you for your quick response.

Oh, Maybe I should just write comments "move_charge_at_immigrate feature
is disabled by default. So add "unlikely", in order to compiler can optimize."

Best Regards,
Wanpeng Li

>--
>To unsubscribe from this list: send the line "unsubscribe cgroups" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
