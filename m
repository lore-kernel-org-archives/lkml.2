Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab1HaOAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:00:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46091 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1HaOAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:00:14 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1314786830.23993.22.camel@twins>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	<CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	<20110830140648.GL9748@somewhere.redhat.com>
	<1314762442.4653.5.camel@marge.simson.net>
	<1314782887.23993.12.camel@twins>
	<1314786377.4653.19.camel@marge.simson.net>
	<1314786830.23993.22.camel@twins>
Date: Wed, 31 Aug 2011 17:00:13 +0300
Message-ID: <CAOtvUMe7PphJtMoGRVUQf9zok+0H1VyS1TAckTJXfJ9p8MHyBA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > cpusets? Afaict all it does is not include a number of cpus in the sched

I think you meant to write cpuisol here :-)

>> > domains, creating a bunch of independent scheduling cpus. You can use
>> > cpusets to get to the same state.

>>
>> Guess I'll have to try creating a cpuset per cpu, and see how it
>> compares to isolcpus.  cset shield --cpu 4-63 didn't work well enough.
>
> You need to play with the sched_load_balance file, no idea what this
> cset utility is though, never encountered it before.
>

It's just a python wrapper around the /cgroup file system.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com
"Dance like no one is watching, love like you'll never be hurt, sing
like no one is listening... but for BEEP sake you better code like
you're going to maintain it for years!"
