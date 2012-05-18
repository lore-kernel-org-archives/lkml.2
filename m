Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2ERPbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:31:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2ERPbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:31:09 -0400
Message-ID: <4FB66B31.3020509@gmail.com>
Date: Fri, 18 May 2012 23:30:57 +0800
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
Organization: NJU
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org> <4FB33A4E.1010208@gmail.com> <20120516065132.GC1769@cmpxchg.org> <4FB3A416.9010703@gmail.com> <20120517210849.GE1800@cmpxchg.org> <4FB5C5A7.6080000@gmail.com> <4FB665B8.8000300@redhat.com>
In-Reply-To: <4FB665B8.8000300@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012年05月18日 23:07, Rik van Riel wrote:
> On 05/17/2012 11:44 PM, Nai Xia wrote:
>
>> But I do think that Clock-pro deserves its credit, since after all
>> it's that research work firstly brought the idea of "refault/reuse
>> distance" to the kernel community.
>
> The ARC people did that, too.

Well, I think you said "take the good parts of clock-pro"...
Anyway, then I think you should credit either of the previous
works... :D

>
>> Further more, it's also good
>> to let the researchers and the community to together have some
>> brain-storm of this problem if it's really hard to deal with in
>> reality.
>
> How much are researchers interested in the real world
> constraints that OS developers have to deal with?

I think there will be nobody, if we don't try to let them
know about the constraints. Honestly, LKML are hard for
researchers to follow. They really need abstract view of
a problem. Surely there is a gap...between researchers and
developers.

>
> Often scalability is as much of a goal as being good
> at selecting the right page to replace...
>
Then scalability might be a good research topic as long
as they have the chance to understand the details.

Ok, all I want to say is another way that may help
the kernel world better. I am actually quite positive
about the patch itself.
