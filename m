Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2GZSjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab2GZSjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:39:32 -0400
Message-ID: <50118E7F.8000609@redhat.com>
Date: Thu, 26 Jul 2012 14:37:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH -alternative] mm: hugetlbfs: Close race during teardown
 of hugetlbfs shared page tables V2 (resend)
References: <20120720134937.GG9222@suse.de> <20120720141108.GH9222@suse.de> <20120720143635.GE12434@tiehlicka.suse.cz> <20120720145121.GJ9222@suse.de> <alpine.LSU.2.00.1207222033030.6810@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1207222033030.6810@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 12:04 AM, Hugh Dickins wrote:

> I spent hours trying to dream up a better patch, trying various
> approaches.  I think I have a nice one now, what do you think?  And
> more importantly, does it work?  I have not tried to test it at all,
> that I'm hoping to leave to you, I'm sure you'll attack it with gusto!
>
> If you like it, please take it over and add your comments and signoff
> and send it in.  The second part won't come up in your testing, and could
> be made a separate patch if you prefer: it's a related point that struck
> me while I was playing with a different approach.
>
> I'm sorely tempted to leave a dangerous pair of eyes off the Cc,
> but that too would be unfair.
>
> Subject-to-your-testing-
> Signed-off-by: Hugh Dickins <hughd@google.com>

This patch looks good to me.

Larry, does Hugh's patch survive your testing?


