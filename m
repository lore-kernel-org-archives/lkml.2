Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1HQQhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab1HQQhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:37:52 -0400
Message-ID: <4E4BEE1F.9060500@redhat.com>
Date: Wed, 17 Aug 2011 09:36:47 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 08:51 AM, Frederic Weisbecker wrote:
> = What's the interface =
>
> We use the cpuset interface by adding a nohz flag to it.
> As long as a CPU is part of a nohz cpuset, then this CPU will
> try to enter into adaptive nohz mode when it can, even if it is part
> of another cpuset that is not nohz.
>
>

Why not do it unconditionally?  That is, if all the conditions are 
fulfilled, disable the tick regardless of any cpuset settings.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

