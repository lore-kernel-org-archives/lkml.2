Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab1DOVqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:46:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160Ab1DOVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:46:14 -0400
Message-ID: <4DA8BC96.6090804@redhat.com>
Date: Fri, 15 Apr 2011 17:45:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/2] sched: next buddy hint on sleep and preempt path
 -v2
References: <1302778202.2035.23.camel@laptop> <1302802253-25760-1-git-send-email-venki@google.com>
In-Reply-To: <1302802253-25760-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 01:30 PM, Venkatesh Pallipadi wrote:

> A simple (may be extreme case) benchmark I tried was tbench with 2 tbench
> client processes with 2 threads each running on a single CPU. Avg throughput
> across 5 50 sec runs was -
> BEFORE: 105.84 MB/sec
> AFTER: 112.42 MB/sec
>
> Signed-off-by: Venkatesh Pallipadi<venki@google.com>

Those performance numbers and the general idea sure get my

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
