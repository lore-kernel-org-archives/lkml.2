Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1CBDwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762Ab1CBDwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:52:34 -0500
Message-ID: <4D6DBEEA.6080603@redhat.com>
Date: Tue, 01 Mar 2011 22:52:10 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: Mike Galbraith <efault@gmx.de>, a.p.zijlstra@chello.nl, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH] sched: resched proper CPU on yield_to
References: <1298885189.9501.2.camel@marge.simson.net> <1299025701-22168-1-git-send-email-venki@google.com>
In-Reply-To: <1299025701-22168-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 07:28 PM, Venkatesh Pallipadi wrote:
> yield_to_task_fair() has code to resched the CPU of yielding task when the
> intention is to resched the CPU of the task that is being yielded to.
>
> Change here fixes the problem and also makes the resched conditional on
> rq != p_rq.
>
> I don't have a setup to test this code path. So, this is only compile tested
> right now.
>
> Signed-off-by: Venkatesh Pallipadi<venki@google.com>

Never mind what I wrote before.  Your patch is correct.
(and I am way tired)

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
