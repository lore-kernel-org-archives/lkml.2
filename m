Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2DIXk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab2DIXk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:40:56 -0400
Message-ID: <4F83737B.7040308@redhat.com>
Date: Mon, 09 Apr 2012 19:40:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [RFC PATCH 0/2] Removal of lumpy reclaim
References: <1332950783-31662-1-git-send-email-mgorman@suse.de> <20120406123439.d2ba8920.akpm@linux-foundation.org> <alpine.LSU.2.00.1204061316580.3057@eggly.anvils> <4F8325FB.80409@redhat.com> <alpine.LSU.2.00.1204091205130.1536@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204091205130.1536@eggly.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 03:18 PM, Hugh Dickins wrote:
> On Mon, 9 Apr 2012, Rik van Riel wrote:

>> I could see NOMMU being unable to use compaction, but
>
> Yes, COMPACTION depends on MMU.
>
>> chances are lumpy reclaim would be sufficient for that
>> configuration, anyway...
>
> That's an argument for your patch in 3.4-rc, which uses lumpy only
> when !COMPACTION_BUILD.  But here we're worrying about Mel's patch,
> which removes the lumpy code completely.

Sorry, that was a typo in my mail.

I wanted to say that I expect lumpy reclaim to NOT be
sufficient for NOMMU anyway, because it cannot reclaim
lumps of memory large enough to fit a new process.

-- 
All rights reversed
