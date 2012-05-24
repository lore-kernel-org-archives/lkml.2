Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692Ab2EXVpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:45:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52197 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab2EXVpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:45:22 -0400
Date: Thu, 24 May 2012 16:45:17 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Anders =?utf-8?Q?Bostr=C3=B6m?= <anders@netinsight.net>
Cc: linux-kernel@vger.kernel.org,
        =?utf-8?B?TGVzxYJhdyBLb3BlxIc=?= <leslaw.kopec@nasza-klasa.pl>,
        Aman Gupta <aman@tmm1.net>, Doug Smythies <dsmythies@telus.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [3.2.16 -> 3.2.17 regression] High reported CPU load when idle
Message-ID: <20120524214516.GB1158@burratino>
References: <20120523.144057.899060240318474097.anders@netinsight.net>
 <20120523215359.GA19798@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120523215359.GA19798@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc-ing Peter and Thomas because there is a nice graph)
> Anders Boström wrote[1]:

>> Starting with 3.2.17-1, the CPU load accounting is broken when the
>> computer is idle. The CPU load is reported as >0.50 when
>> idle. 3.2.16-1 don't suffer from this problem.
>>
>> Suspected patch is the upstream patch
>> "sched: Fix nohz load accounting -- again!"
>> commit 5e2d50da11f0e6ec3ce8fe658d7c83b0b4346c68 to 3.2 and
>> originating from c308b56b5398779cd3da0f62ab26b0453494c3d4 .
>>
>> See also:
>>
>> https://bugs.launchpad.net/unity/+bug/991370
>> https://lkml.org/lkml/2012/5/22/310
>> https://bugzilla.redhat.com/show_bug.cgi?id=822877
>> https://bbs.archlinux.org/viewtopic.php?id=141289

I just found [1] from [2] which seems to describe the symptoms pretty
well.  Peter, Thomas, advice?

Anders et al: does 556061b00c9f ("sched/nohz: Fix rq->cpu_load[]
calculations", 2012-05-11) change anything?

Thanks,
Jonathan

[1] https://launchpadlibrarian.net/105809696/commit_low_load_rev2.png
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/838811
