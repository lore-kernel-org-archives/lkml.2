Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0KIUvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:51:45 -0500
Received: from freeflow.nu ([178.79.134.28]:53438 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0KIUvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:51:43 -0500
Message-ID: <4CD9B463.6090504@kernel.org>
Date: Tue, 09 Nov 2010 22:51:47 +0200
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
References: <20101025235804.GA11760@outflux.net> <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com> <20101109205008.GU5876@outflux.net>
In-Reply-To: <20101109205008.GU5876@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.11.2010 22.50, Kees Cook wrote:
> Hi Pekka,
>
> On Tue, Nov 09, 2010 at 10:43:07PM +0200, Pekka Enberg wrote:
>> On Tue, Oct 26, 2010 at 2:58 AM, Kees Cook<kees.cook@canonical.com>  wrote:
>>> CVE-2010-4072
>>>
>>> The old shm interface will leak a few bytes of stack contents. Explicitly
>>> clear structure using memset instead of C99-style initialization in case
>>> there are ever holes in the packing.
>>>
>>> Cc: stable<stable@kernel.org>
>>> Signed-off-by: Kees Cook<kees.cook@canonical.com>
>> This looks like a genuine bug fix but I don't see this patch in
>> mainline. Why is that?
> No one has committed it. I don't know why; I've sent it a few times now.

Andrew, would you mind picking this up and route it to the appropriate 
person if necessary?

Acked-by: Pekka Enberg <penberg@kernel.org>

             Pekka
