Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1FMUeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:34:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58543 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1FMUeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=iV0JoHmNKZVpdQ0YRvXSoDiinbtlS8ccfDtcX+iADMLLem6eYSgn7vPSDgWmW9UQ6o
         btG7ZVMgeh3Vj2OwNGIOxExb5+rc6EQAfpxzAdKajLxVi/ePqZu8z2vtEozIK1zKwMBa
         7ZvUBTQQ9SA//nm8GGbR6deA5PS/F+sh5j/Lc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106131428560.5601@router.home>
References: <alpine.LSU.2.00.1106121842250.31463@sister.anvils>
	<alpine.DEB.2.00.1106131258300.3108@router.home>
	<1307990048.11288.3.camel@jaguar>
	<alpine.DEB.2.00.1106131428560.5601@router.home>
Date: Mon, 13 Jun 2011 23:34:22 +0300
X-Google-Sender-Auth: o5lEJQSPvCnxK0u-asRlEp7diZ0
Message-ID: <BANLkTi=RYq0Dd210VC+NeTXWWuFbz7cxeg@mail.gmail.com>
Subject: Re: [PATCH] slub: fix kernel BUG at mm/slub.c:1950!
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 10:29 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 13 Jun 2011, Pekka Enberg wrote:
>
>> > Hmmm.. The allocpercpu in alloc_kmem_cache_cpus should take care of the
>> > alignment. Uhh.. I see that a patch that removes the #ifdef CMPXCHG_LOCAL
>> > was not applied? Pekka?
>>
>> This patch?
>>
>> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=d4d84fef6d0366b585b7de13527a0faeca84d9ce
>>
>> It's queued and will be sent to Linus soon.
>
> Ok it will also fix Hugh's problem then.

It's in Linus' tree now. Hugh, can you please confirm it fixes your machine too?
