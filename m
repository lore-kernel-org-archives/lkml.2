Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2KTAlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:41:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab2KTAlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:41:51 -0500
Message-ID: <50AAD1AC.7090209@redhat.com>
Date: Mon, 19 Nov 2012 19:41:16 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
References: <1353291284-2998-1-git-send-email-mingo@kernel.org> <20121119162909.GL8218@suse.de> <20121119191339.GA11701@gmail.com> <20121119211804.GM8218@suse.de> <20121119223604.GA13470@gmail.com> <20121119230034.GO8218@suse.de>
In-Reply-To: <20121119230034.GO8218@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 06:00 PM, Mel Gorman wrote:
> On Mon, Nov 19, 2012 at 11:36:04PM +0100, Ingo Molnar wrote:
>>
>> * Mel Gorman <mgorman@suse.de> wrote:
>>
>>> Ok.
>>>
>>> In response to one of your later questions, I found that I had
>>> in fact disabled THP without properly reporting it. [...]
>>
>> Hugepages is a must for most forms of NUMA/HPC.
>
> Requiring huge pages to avoid a regression is a mistake.

Not all architectures support THP.  Not all workloads will end up
using THP effectively.

Mel, would you have numa/core profiles from !THP runs, so we can
find out the cause of the regression?

-- 
All rights reversed
