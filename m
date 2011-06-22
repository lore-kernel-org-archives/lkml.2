Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1FVFp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 01:45:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab1FVFp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 01:45:27 -0400
Message-ID: <4E01816A.3040309@redhat.com>
Date: Wed, 22 Jun 2011 13:45:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm: completely disable THP by transparent_hugepage=0
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211814250.5205@chino.kir.corp.google.com> <4E015CB8.1010300@redhat.com> <alpine.DEB.2.00.1106212010520.8712@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106212010520.8712@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月22日 11:24, David Rientjes 写道:
> On Wed, 22 Jun 2011, Cong Wang wrote:
>
>>>> Introduce "transparent_hugepage=0" to totally disable THP.
>>>> "transparent_hugepage=never" means setting THP to be partially
>>>> disabled, we need a new way to totally disable it.
>>>>
>>>
>>> Why can't you just compile it off so you never even compile
>>> mm/huge_memory.c in the first place and save the space in the kernel image
>>> as well?  Having the interface available to enable the feature at runtime
>>> is worth the savings this patch provides, in my opinion.
>>
>> https://lkml.org/lkml/2011/6/20/506
>>
>
> If you're proposing a patch for a specific purpose, it's appropriate to
> include that in the changelog.

Sorry, I can't put everything you don't see into the changelog.

>
> But now that I know what you're proposing this for, it's an easy NACK:
> transparent_hugepage=0 has no significant benefit over
> transparent_hugepage=never for kdump because the memory savings is
> negligible.

I hate to repeat things, sorry, please go for the other thread where I
replied to Andrea.

