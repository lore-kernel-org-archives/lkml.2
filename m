Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab2JFNUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 09:20:11 -0400
Received: from smtp.getmail.no ([84.208.15.66]:52025 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab2JFNUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 09:20:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: david@lang.hm
Subject: Re: Minimal jitter = good desktop.
References: <op.wlqe9kw36426ze@localhost.localdomain>
 <alpine.DEB.2.02.1210051803180.13407@asgard.lang.hm>
Date: Sat, 06 Oct 2012 15:19:58 +0200
Cc: linux-kernel@vger.kernel.org
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlrdzkqh6426ze@localhost.localdomain>
In-reply-to: <alpine.DEB.2.02.1210051803180.13407@asgard.lang.hm>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the context of os-jitter, delay/latency is measured as jitter.

Peace Be With You.

On Sat, 06 Oct 2012 03:06:57 +0200, <david@lang.hm> wrote:

> less jitter != less latency
>
> you could (in theory) eliminate jitter by delaying every keypress  
> processed for exactly 1 second by having the code paths that process  
> keypresses faster insert delays before implementing the results.
>
> that would result in zero jitter, but horrific latency.
>
> latency is how long it takes to do something, jitter is how much the  
> latency varies.
>
> normally, if you optimize for one you make the other worse.
>
> If you optimize for latency, you try to finish everything as soon as you  
> can. Since some things take longer than others, jitter increases.
>
> David Lang
>
> On Sat, 6 Oct 2012, Uwaysi Bin Kareem wrote:
>
>> Reducing jitter seems central for many things.
>> First of all keypresses seem faster. (less jitter = less latency).
>> Doom 3 and similar jittersensitive OpenGL applications run smoothly,  
>> and better than windows. Doom 3 was also my main app to get running  
>> well, and measuring jitter in the signalpath of OpenGL improved the  
>> overall computing experience.
>>
>> Even youtube videos who are not synced to refresh, with a refresh of  
>> 60, and a videofps of 30, runs quite well.  
>> http://paradoxuncreated.com/Blog/wordpress/?p=3221
>>
>> System is responsive, and I have only had one problem, and that is  
>> packing seems not to work at the moment.
>>
>> For a fast test in Ubuntu, try  
>> http://paradoxuncreated.com/Blog/wordpress/?p=2268
>>
>> Definately a recommended config on the desktop.
>>
>> Peace Be With You.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"  
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
