Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1FVDLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726Ab1FVDLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:11:35 -0400
Message-ID: <4E015D5C.4010809@redhat.com>
Date: Wed, 22 Jun 2011 11:11:24 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@xenotime.net>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm: completely disable THP by transparent_hugepage=0
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <20110621133053.GO20843@redhat.com>
In-Reply-To: <20110621133053.GO20843@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 21:30, Andrea Arcangeli 写道:
> On Tue, Jun 21, 2011 at 04:10:42PM +0800, Amerigo Wang wrote:
>> Introduce "transparent_hugepage=0" to totally disable THP.
>> "transparent_hugepage=never" means setting THP to be partially
>> disabled, we need a new way to totally disable it.
>>
>
> I think I already clarified this is not worth it. Removing sysfs
> registration is just pointless. If you really want to save ~8k of RAM,
> at most you can try to move the init of the khugepaged slots hash and
> the kmem_cache_init to the khugepaged deamon start but even that isn't
> so useful. Not registering into sysfs is just pointless and it's a
> gratuitous loss of a feature.

Sorry, I replied to you in the other thread, so I don't want to dup
it here.

