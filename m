Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2DXGw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:52:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63983 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2DXGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:52:54 -0400
Message-ID: <4F964DC1.2020703@gmail.com>
Date: Tue, 24 Apr 2012 08:52:49 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dario Faggioli <raistlin@linux.it>
CC: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        insop.song@ericsson.com, liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>    <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>   <1335177104.28150.113.camel@twins> <4F9530F7.9010400@gmail.com>   <4F95C8AF.2040606@sssup.it> <1335217531.28150.179.camel@twins>  <4F95E4EF.2080802@sssup.it> <1335248967.2397.8.camel@Abyss>
In-Reply-To: <1335248967.2397.8.camel@Abyss>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 08:29 AM, Dario Faggioli wrote:
> On Tue, 2012-04-24 at 00:25 +0100, Tommaso Cucinotta wrote:
>>> The idea is that ->clock_task gives the time as observed by schedulable
>>> tasks and excludes other muck.
>>
>> so clock_task might be better to compute the consumed budget at task
>> deschedule, but for setting deadlines one period ahead in the future
>> guess the regular wall-time rq->clock is the one to be used?
>>
> Yep, that was the idea, unless my recollection has completely gone
> flaky! :-P
>
> Perhaps adding a comment saying right this thing above, as Peter
> suggested?
>

Sure! TODO for the next release :-).

Thanks,

- Juri
