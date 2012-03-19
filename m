Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab2CSUOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:14:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759168Ab2CSUOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:14:54 -0400
Message-ID: <4F6793B0.50601@redhat.com>
Date: Mon, 19 Mar 2012 16:14:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: forbid lumpy-reclaim in shrink_active_list()
References: <20120319091821.17716.54031.stgit@zurg> <4F676FA4.50905@redhat.com> <4F6773CC.2010705@openvz.org> <4F6774E8.2050202@redhat.com> <alpine.LSU.2.00.1203191239570.3498@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1203191239570.3498@eggly.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 04:05 PM, Hugh Dickins wrote:
> On Mon, 19 Mar 2012, Rik van Riel wrote:

>> It was done that way, because Mel explained to me that deactivating
>> a whole chunk of active pages at once is a desired feature that makes
>> it more likely that a whole contiguous chunk of pages will eventually
>> reach the end of the inactive list.
>
> I'm rather sceptical about this: is there a test which demonstrates
> a useful effect of that kind?

I am somewhat sceptical too, but since lumpy reclaim is
due to be removed anyway, I did not bother to investigate
its behaviour in any detail :)

-- 
All rights reversed
