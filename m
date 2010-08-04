Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab0HDNn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:43:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:40864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab0HDNnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:43:55 -0400
Message-ID: <4C596E97.6060508@kernel.org>
Date: Wed, 04 Aug 2010 15:43:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] workqueue: mark init_workqueues() as early_initcall()
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>	 <4C55556C.6050206@kernel.org> <1280774463.2703.6.camel@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <1280774463.2703.6.camel@sbsiddha-MOBL3.sc.intel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 Aug 2010 13:43:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 08:41 PM, Suresh Siddha wrote:
> On Sun, 2010-08-01 at 12:07 +0100, Tejun Heo wrote:
>> Audited and tested.  It should be fine.  Patch applied and pushed out
>> to linux-next.  How shall we route the second patch?
>>
> 
> Tejun, v2 version of the second patch had both x86 and ia64 changes.
> 
> http://marc.info/?l=linux-kernel&m=128053714303108&w=2
> 
> So I am ok if you carry this with the rest of your workqueue changes
> that touch these same files.

Andrew seemed to have already picked up the patch.  I've sent the pull
request with the first patch.

Thank you.

-- 
tejun
