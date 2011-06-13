Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1FMVAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:00:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57346 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1FMVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W5Od/wd6OpqJLvztadhnf157xra5Gt99pPcgaxMJofbbbPoEt88oqS+7sKvZPeR3N/
         3augsa7Xs0B69sOmBKtA==
MIME-Version: 1.0
In-Reply-To: <BANLkTi=RYq0Dd210VC+NeTXWWuFbz7cxeg@mail.gmail.com>
References: <alpine.LSU.2.00.1106121842250.31463@sister.anvils>
	<alpine.DEB.2.00.1106131258300.3108@router.home>
	<1307990048.11288.3.camel@jaguar>
	<alpine.DEB.2.00.1106131428560.5601@router.home>
	<BANLkTi=RYq0Dd210VC+NeTXWWuFbz7cxeg@mail.gmail.com>
Date: Mon, 13 Jun 2011 14:00:31 -0700
Message-ID: <BANLkTik-KGtuoVFKvy_rk7voBRAxSsR9FRg0fhb0k3NCSg-fWQ@mail.gmail.com>
Subject: Re: [PATCH] slub: fix kernel BUG at mm/slub.c:1950!
From: Hugh Dickins <hughd@google.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 1:34 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Mon, Jun 13, 2011 at 10:29 PM, Christoph Lameter <cl@linux.com> wrote:
>> On Mon, 13 Jun 2011, Pekka Enberg wrote:
>>
>>> > Hmmm.. The allocpercpu in alloc_kmem_cache_cpus should take care of the
>>> > alignment. Uhh.. I see that a patch that removes the #ifdef CMPXCHG_LOCAL
>>> > was not applied? Pekka?
>>>
>>> This patch?
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=d4d84fef6d0366b585b7de13527a0faeca84d9ce
>>>
>>> It's queued and will be sent to Linus soon.
>>
>> Ok it will also fix Hugh's problem then.
>
> It's in Linus' tree now. Hugh, can you please confirm it fixes your machine too?

I expect it to, thanks: I'll confirm tonight.

Hugh
