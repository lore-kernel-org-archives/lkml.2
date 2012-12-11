Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2LKTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:09:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36900 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab2LKTJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:09:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121211183937.GA5168@cmpxchg.org>
References: <1355213523-15698-1-git-send-email-linfeng@cn.fujitsu.com>
	<20121211183937.GA5168@cmpxchg.org>
Date: Tue, 11 Dec 2012 11:09:54 -0800
X-Google-Sender-Auth: 0ySQj5k1s0a0dmrdTLQwGc6RTrE
Message-ID: <CAE9FiQVtsd90x3cpaZWK+oVUydApb9YVON3LNV1+cP9_0uCWzw@mail.gmail.com>
Subject: Re: [PATCH] mm/bootmem.c: remove unused wrapper function reserve_bootmem_generic()
From: Yinghai Lu <yinghai@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lin Feng <linfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        hpa@zytor.com, davem@davemloft.net, eric.dumazet@gmail.com,
        tj@kernel.org, shangw@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:39 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Dec 11, 2012 at 04:12:03PM +0800, Lin Feng wrote:
>> Wrapper fucntion reserve_bootmem_generic() currently have no caller,
>> so clean it up.
>>
>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

yes, this is leftover from

commit 774ea0bcb27f57b6fd521b3b6c43237782fed4b9
Date:   Wed Aug 25 13:39:18 2010 -0700

    x86: Remove old bootmem code

    Requested by Ingo, Thomas and HPA.

    The old bootmem code is no longer necessary, and the transition is
    complete.  Remove it.
