Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0ITDJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 23:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0ITDJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 23:09:52 -0400
Message-ID: <4C96D072.5080305@redhat.com>
Date: Sun, 19 Sep 2010 23:09:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Greg KH <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: further fix swapin race condition
References: <20100903153958.GC16761@random.random> <alpine.LSU.2.00.1009051926330.12092@sister.anvils> <alpine.LSU.2.00.1009151534060.5630@tigran.mtv.corp.google.com> <20100915234237.GR5981@random.random> <alpine.DEB.2.00.1009151703060.7332@tigran.mtv.corp.google.com> <20100916210349.GU5981@random.random> <alpine.LSU.2.00.1009161905190.2517@tigran.mtv.corp.google.com> <20100918131907.GI18596@random.random> <alpine.LSU.2.00.1009191924110.2779@sister.anvils> <alpine.LSU.2.00.1009191938110.3025@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1009191938110.3025@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2010 10:40 PM, Hugh Dickins wrote:
> Commit 4969c1192d15afa3389e7ae3302096ff684ba655 "mm: fix swapin race condition"
> is now agreed to be incomplete.  There's a race, not very much less likely
> than the original race envisaged, in which it is further necessary to check
> that the swapcache page's swap has not changed.

> B ought to have checked that page1's swap was still swap1.
>
> Signed-off-by: Hugh Dickins<hughd@google.com>
> Cc: stable@kernel.org

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
