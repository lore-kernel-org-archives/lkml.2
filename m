Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab0ELVSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:18:40 -0400
Received: from dm-mail02.mozilla.org ([63.245.208.176]:50039 "EHLO
	dm-mail02.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab0ELVS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:18:28 -0400
Message-ID: <4BEB1B10.40200@mozilla.com>
Date: Wed, 12 May 2010 14:18:08 -0700
From: Taras Glek <tglek@mozilla.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: How to use perf to log page faults
References: <4BEB03B6.6080706@mozilla.com> <20100512195945.GE10028@nowhere>
In-Reply-To: <20100512195945.GE10028@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 12:59 PM, Frederic Weisbecker wrote:
> On Wed, May 12, 2010 at 12:38:30PM -0700, Taras Glek wrote:
>    
>> Hi,
>>  From the docs it seems that perf may be useful for logging page faults.
>> I tried
>> perf record -g -d -f -e page-faults<mycommand>
>> but all I got were PERF_RECORD_MMAP events.
>>
>> I'm using 2.6.32. Ideally I'd like to collect fault addresses and
>> userspace stacks that caused them. Isn't this what the page-fault event
>> is for?
>>
>> Taras
>>      
>
> Could you try with -c 1 ?
>
> Otherwise, does that work on the latest kernel?
>    
this just gets me PERF_RECORD_SAMPLE events which don't seem to be 
related to page-faults(ie they show up with/without -e page-faults).

I don't have the latest kernel installed here. Can you get perf 
page-fault events on your system?

Taras

