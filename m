Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab0ELV3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:29:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59470 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab0ELV3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S5iJk2RWbmSZXjJkwmmprKvGxalPh3W/8tttl/omctXL/jbI/nzjNfCe5LlnXZmHg7
         Tj3QDfx5X5CHopzI2X6W7r2J2DuV45ziAIqGGVX+jv7IWSASzElZacs6trzBlcBGyMtK
         7xs5pG3KgPFXkZE6RMyQS/gqIp7UM7UnN60h4=
Date: Wed, 12 May 2010 23:29:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Taras Glek <tglek@mozilla.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: How to use perf to log page faults
Message-ID: <20100512212942.GI10028@nowhere>
References: <4BEB03B6.6080706@mozilla.com> <20100512195945.GE10028@nowhere> <4BEB1B10.40200@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEB1B10.40200@mozilla.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:18:08PM -0700, Taras Glek wrote:
> On 05/12/2010 12:59 PM, Frederic Weisbecker wrote:
>> On Wed, May 12, 2010 at 12:38:30PM -0700, Taras Glek wrote:
>>    
>>> Hi,
>>>  From the docs it seems that perf may be useful for logging page faults.
>>> I tried
>>> perf record -g -d -f -e page-faults<mycommand>
>>> but all I got were PERF_RECORD_MMAP events.
>>>
>>> I'm using 2.6.32. Ideally I'd like to collect fault addresses and
>>> userspace stacks that caused them. Isn't this what the page-fault event
>>> is for?
>>>
>>> Taras
>>>      
>>
>> Could you try with -c 1 ?
>>
>> Otherwise, does that work on the latest kernel?
>>    
> this just gets me PERF_RECORD_SAMPLE events which don't seem to be  
> related to page-faults(ie they show up with/without -e page-faults).
>
> I don't have the latest kernel installed here. Can you get perf  
> page-fault events on your system?


Yeah, no problem on 2.6.34-rc7.

