Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024Ab2BVFLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 00:11:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58548 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2BVFLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 00:11:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.125.12 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F447904.90500@openvz.org>
Date: Wed, 22 Feb 2012 09:11:32 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2 00/22] mm: lru_lock splitting
References: <20120220171138.22196.65847.stgit@zurg> <m2boor33g8.fsf@firstfloor.org>
In-Reply-To: <m2boor33g8.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Konstantin Khlebnikov<khlebnikov@openvz.org>  writes:
>
> Konstantin,
>
>> There complete patch-set with my lru_lock splitting
>> plus all related preparations and cleanups rebased to next-20120210
>
> On large systems we're also seeing lock contention on the lru_lock
> without using memcgs. Any thoughts how this could be extended for this
> situation too?

We can split lru_lock by pfn-based interleaving.
After all these cleanups it is very easy. I already have patch for this.

>
> Thanks,
>
> -Andi
>

