Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0GaK3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 06:29:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:55306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0GaK3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 06:29:19 -0400
Message-ID: <4C53FAEC.6060903@kernel.org>
Date: Sat, 31 Jul 2010 12:29:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 1/2] workqueue: mark init_workqueues() as early_initcall()
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>	 <20100730165522.22dc982b.akpm@linux-foundation.org> <1280537290.2682.19.camel@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <1280537290.2682.19.camel@sbsiddha-MOBL3.sc.intel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 31 Jul 2010 10:28:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/31/2010 02:48 AM, Suresh Siddha wrote:
> hmm.. too many changes in linux-next.
> 
> Yes, as far as these patches are concerned, they work against linux-next
> aswell. Just posted -v2 which is on top of linux-next. ia64 also had the
> same issue, addressed in -v2 aswell.

I think it'll be best to route the changes through workqueue tree.
I'll audit init path and if everything looks okay will add the
workqueue patch to wq#for-next.

Thank you.

-- 
tejun
