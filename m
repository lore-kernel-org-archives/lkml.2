Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1FVFlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 01:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab1FVFlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 01:41:32 -0400
Message-ID: <4E018060.3050607@redhat.com>
Date: Wed, 22 Jun 2011 13:40:48 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        dave@linux.vnet.ibm.com, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm: make the threshold of enabling THP configurable
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-2-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211817340.5205@chino.kir.corp.google.com> <4E015C36.2050005@redhat.com> <alpine.DEB.2.00.1106212024210.8712@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106212024210.8712@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月22日 11:29, David Rientjes 写道:
>
> Either way, this patch isn't needed since it has no benefit over doing it
> through an init script.

If you were right, CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not needed,
you can do it through an init script.

If you were right, the 512M limit is not needed neither, you have
transparent_hugepage=never boot parameter and do the check of
512M later in an init script. (Actually, moving the 512M check to
user-space is really more sane to me.)

I am quite sure you have lots of other things which both have a Kconfig
and a boot parameter, why do we have it?
