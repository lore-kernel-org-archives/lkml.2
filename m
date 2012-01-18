Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2ARObk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:31:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab2ARObj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:31:39 -0500
Message-ID: <4F16D79C.2020402@redhat.com>
Date: Wed, 18 Jan 2012 09:30:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: leonid.moiseichuk@nokia.com
CC: penberg@kernel.org, minchan@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        mel@csn.ul.ie, rientjes@google.com, kosaki.motohiro@gmail.com,
        hannes@cmpxchg.org, mtosatti@redhat.com, akpm@linux-foundation.org,
        rhod@redhat.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC 1/3] /dev/low_mem_notify
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <1326788038-29141-2-git-send-email-minchan@kernel.org> <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com> <4F15A34F.40808@redhat.com> <alpine.LFD.2.02.1201172044310.15303@tux.localdomain> <84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com>
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 04:06 AM, leonid.moiseichuk@nokia.com wrote:

> Would be possible to use for threshold pointed value(s) e.g. according to enum zone_state_item, because kinds of memory to track could be different?
> E.g. to tracking paging activity NR_ACTIVE_ANON and NR_ACTIVE_FILE could be interesting, not only free.

That seems like a horrible idea, because there is no guarantee that
the kernel will continue to use NR_ACTIVE_ANON and NR_ACTIVE_FILE
internally in the future.

What is exported to userspace must be somewhat independent of the
specifics of how the kernel implements things internally.

-- 
All rights reversed
