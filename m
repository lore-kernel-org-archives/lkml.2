Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0EXUpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:45:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0EXUpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:45:32 -0400
Message-ID: <4BFAE533.6080603@redhat.com>
Date: Mon, 24 May 2010 16:44:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       davej@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2  0/8] Fix performance issue with ondemand governor
References: <20100509082126.4a080d46@infradead.org> <20100509174936.GB17881@elte.hu>
In-Reply-To: <20100509174936.GB17881@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2010 01:49 PM, Ingo Molnar wrote:
> * Arjan van de Ven<arjan@infradead.org>  wrote:
>
>> [Version 2 includes the acks/etc. Andrew: no changes from the patches that
>> are in -mm]
>>
>> There have been various reports of the ondemand governor causing some
>> serious performance issues, one of the latest ones from Andrew. There are
>> several fundamental issues with ondemand (being worked on), but the report
>> from Andrew can be fixed relatively easily.
>>
>> The fundamental issue is that ondemand will go to a (too) low CPU frequency
>> for workloads that alternatingly disk and CPU bound...
>
> I've applied your series to sched/core and started testing it, thanks Arjan!

This code seems to help significantly with some workloads,
allowing more systems to use the ondemand governor (and
having fewer systems waste power by using the performance
governor all the time).

It would be nice to see it in 2.6.35

-- 
All rights reversed
