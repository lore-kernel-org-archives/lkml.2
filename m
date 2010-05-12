Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0ELOlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab0ELOlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:41:31 -0400
Message-ID: <4BEABDF8.40206@redhat.com>
Date: Wed, 12 May 2010 16:40:56 +0200
From: Jan Safranek <jsafrane@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dhaval Giani <dhaval.giani@gmail.com>, James Kosin <jkosin@intcomgrp.com>,
       linux-kernel@vger.kernel.org, menage@google.com,
       balbir@linux.vnet.ibm.com, lennart@poettering.net, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com> <1273674048.1626.117.camel@laptop>
In-Reply-To: <1273674048.1626.117.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 04:20 PM, Peter Zijlstra wrote:
> On Wed, 2010-05-12 at 16:13 +0200, Dhaval Giani wrote:
>> What you are saying is that an application
>> programmer who wants to just use memory cgroups should also care about
>> cpusets and just about countless other cgroup subsystems that can
>> exist.
>
> That's exactly what he says if he mounts them together.

No, the programmer does not mount anything. Programmer writes 
application which wants to create a subgroup. System admin is the one 
who decides what is mounted how. And the programmer (=me) needs a way 
how to reliably create a subgroup, without knowing details about all 
controllers. E.g. 'blkio' controller is quite new one, old applications 
do now know anything about it, yet according to your idea, the 
application *must* provide sane defaults to it.

Jan

