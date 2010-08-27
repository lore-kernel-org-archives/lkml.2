Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0H0JiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:38:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:58043 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab0H0JiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:38:11 -0400
Message-ID: <4C778623.6000303@kernel.org>
Date: Fri, 27 Aug 2010 11:32:19 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Huang Shijie <shijie8@gmail.com>, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu: fix a memory leak in pcpu_extend_area_map()
References: <1281261197-8816-1-git-send-email-shijie8@gmail.com>	<4C5EA651.7080009@kernel.org> <20100826151017.63b20d2e.akpm@linux-foundation.org>
In-Reply-To: <20100826151017.63b20d2e.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 09:38:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/27/2010 12:10 AM, Andrew Morton wrote:
>> Patch applied to percpu#for-linus w/ some updates.  Thanks a lot for
>> catching this.
> 
> This patch appears to have been lost?

It has been in percpu#for-linus.  Given the way percpu allocator is
currently used, the bug isn't likely to cause any real leakage, so I
was waiting a bit before pushing it out.  I'll push it today.

Thanks.

-- 
tejun
