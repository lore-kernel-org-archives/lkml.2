Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab1KKM1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:27:45 -0500
Received: from hera.cwi.nl ([192.16.191.8]:50231 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1KKM1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:27:44 -0500
Message-ID: <4EBD14B4.5000201@cwi.nl>
Date: Fri, 11 Nov 2011 12:27:32 +0000
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Icedove/3.1.15
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: len.brown@intel.com, pavel@ucw.cz, linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL deref in swapin_readahead
References: <4EBD0767.8040901@cwi.nl> <201111111307.02203.rjw@sisk.pl>
In-Reply-To: <201111111307.02203.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/11/2011 12:07 PM, Rafael J. Wysocki wrote:
> Well, the trace doesn't indicate how the problem is related to the
> suspend/resume code paths.
>
> Is this a regression for you?
>
> Thanks,
> Rafael
Hi Rafael,

This problem manifests itself when resuming from RAM, but only very 
infrequently. This is the third occurrence since I started using this 
machine three months ago. I suspend it to RAM at least twice a day. The 
previous two occurrences were on 3.0. So not a clear regression in that 
sense. (Note this is from memory, I didn't record those other two oopses)

However, since it happens immediately upon resume, I suspected it was 
related. Would you have any tips for stress testing resumes? If I can 
increase the reproducibility then I could try to bisect it.

Or do you think it better, judging from the back trace, to forward this 
to some other subsystem maintainer? Please do then, I obviously don't 
know how to read backtraces.

Thanks,

Wouter


