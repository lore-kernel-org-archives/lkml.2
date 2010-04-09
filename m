Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0DIPhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab0DIPhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:37:08 -0400
Message-ID: <4BBF4969.3090906@redhat.com>
Date: Fri, 09 Apr 2010 11:36:09 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 10/13] lockdep, mutex: Provide mutex_lock_nest_lock
References: <20100408191737.296180458@chello.nl> <20100408192723.030209643@chello.nl>
In-Reply-To: <20100408192723.030209643@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 03:17 PM, Peter Zijlstra wrote:
> Provide the mutex_lock_nest_lock() annotation.
>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>

Reviewed-by: Rik van Riel <riel@redhat.com>

