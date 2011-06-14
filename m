Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab1FNSVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1FNSU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:20:59 -0400
Message-ID: <4DF7A658.2010009@redhat.com>
Date: Tue, 14 Jun 2011 14:20:08 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Robin Holt <holt@sgi.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/12] tmpfs: convert from old swap vector to radix tree
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <BANLkTintgwYuUcMjY91gGk8G07wmWyQ1sw@mail.gmail.com>
In-Reply-To: <BANLkTintgwYuUcMjY91gGk8G07wmWyQ1sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 01:29 PM, Linus Torvalds wrote:
> On Tue, Jun 14, 2011 at 3:40 AM, Hugh Dickins<hughd@google.com>  wrote:
>>
>> thus saving memory, and simplifying its code and locking.
>>
>>   13 files changed, 669 insertions(+), 1144 deletions(-)
>
> Hey, I can Ack this just based on the fact that for once "simplifying
> its code" clearly also removes code. Yay! Too many times the code
> becomes "simpler" but bigger.

I looked through Hugh's patches for a while and didn't
see anything wrong with the code.  Consider all patches

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
