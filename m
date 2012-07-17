Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2GQKgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:36:33 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50718 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2GQKga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:36:30 -0400
Message-ID: <50053FE4.7070509@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 16:05:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, pjt@google.com, suresh.b.siddha@intel.com,
        seto.hidetoshi@jp.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de,
        dhillf@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/cpu hotplug: Don't traverse sched domain tree of
 cpus going offline
References: <20120602185721.5559.65562.stgit@srivatsabhat> <4FE19CF5.3060000@linux.vnet.ibm.com> <1340187450.21745.96.camel@twins>
In-Reply-To: <1340187450.21745.96.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071700-1396-0000-0000-00000191ACBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 06/20/2012 03:47 PM, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 15:20 +0530, Srivatsa S. Bhat wrote:
>> Any thoughts on this patch?
>>
> Yeah, I stared at it for a while and got a head-ache.. the idle-balance
> part if ok, the rt.c part needs a little more-thinking.
>

Could you kindly elaborate about the concern you had regarding the rt.c
part? Thanks!
 
> Thanks for reminding me.. I'll try and have another look.
> 

Regards,
Srivatsa S. Bhat

