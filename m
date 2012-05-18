Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2ERPHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2ERPHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:07:53 -0400
Message-ID: <4FB665B8.8000300@redhat.com>
Date: Fri, 18 May 2012 11:07:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: nai.xia@gmail.com
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org> <4FB33A4E.1010208@gmail.com> <20120516065132.GC1769@cmpxchg.org> <4FB3A416.9010703@gmail.com> <20120517210849.GE1800@cmpxchg.org> <4FB5C5A7.6080000@gmail.com>
In-Reply-To: <4FB5C5A7.6080000@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 11:44 PM, Nai Xia wrote:

> But I do think that Clock-pro deserves its credit, since after all
> it's that research work firstly brought the idea of "refault/reuse
> distance" to the kernel community.

The ARC people did that, too.

> Further more, it's also good
> to let the researchers and the community to together have some
> brain-storm of this problem if it's really hard to deal with in
> reality.

How much are researchers interested in the real world
constraints that OS developers have to deal with?

Often scalability is as much of a goal as being good
at selecting the right page to replace...

-- 
All rights reversed
