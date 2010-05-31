Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0EaHA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:00:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:46794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137Ab0EaHAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:00:50 -0400
Message-ID: <4C035E71.7000106@kernel.org>
Date: Mon, 31 May 2010 09:00:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev <netdev@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] cgroups: Add an API to attach a task to current task's
 cgroup
References: <20100527091426.GA6308@redhat.com> <20100527124448.GA4241@redhat.com> <20100527131254.GB7974@redhat.com> <4BFE9ABA.6030907@kernel.org> <20100527163954.GA21710@redhat.com> <4BFEA434.6080405@kernel.org> <20100527173207.GA21880@redhat.com> <4BFEE216.2070807@kernel.org> <20100528150830.GB21880@redhat.com> <4BFFE742.2060205@kernel.org> <20100530112925.GB27611@redhat.com> <4C02C987.6020805@kernel.org> <4C030BC1.6000607@cn.fujitsu.com>
In-Reply-To: <4C030BC1.6000607@cn.fujitsu.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 07:00:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 03:07 AM, Li Zefan wrote:
> 04:24, Tejun Heo wrote:
>> From: Sridhar Samudrala <samudrala.sridhar@gmail.com>
>>
>> Add a new kernel API to attach a task to current task's cgroup
>> in all the active hierarchies.
>>
>> Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
> 
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> btw: you lost the reviewed-by tag given by Paul Menage.

I only got bounced the original posting.  Michael, can you please add
it if/when you commit these?

Thank you.

-- 
tejun
