Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1AUOgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:36:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1AUOgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:36:31 -0500
Message-ID: <4D3999BC.7000107@redhat.com>
Date: Fri, 21 Jan 2011 09:35:40 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] mm: System without MMU do not need pte_mkwrite
References: <1295596196-8233-1-git-send-email-monstr@monstr.eu> <1295596196-8233-2-git-send-email-monstr@monstr.eu>
In-Reply-To: <1295596196-8233-2-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 02:49 AM, Michal Simek wrote:
> The patch "thp: export maybe_mkwrite"
> (sha1 14fd403f2146f740942d78af4e0ee59396ad8eab)
> break systems without MMU.
>
> Error log:
>    CC      arch/microblaze/mm/init.o
> In file included from include/linux/mman.h:14,
>                   from arch/microblaze/mm/consistent.c:24:
> include/linux/mm.h: In function 'maybe_mkwrite':
> include/linux/mm.h:482: error: implicit declaration of function 'pte_mkwrite'
> include/linux/mm.h:482: error: incompatible types in assignment
>
> Signed-off-by: Michal Simek<monstr@monstr.eu>
> CC: Andrea Arcangeli<aarcange@redhat.com>
> CC: Linus Torvalds<torvalds@linux-foundation.org>
> CC: Andrew Morton<akpm@linux-foundation.org>
> CC: Rik van Riel<riel@redhat.com>
> CC: Ingo Molnar<mingo@elte.hu>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
