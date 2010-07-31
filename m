Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0GaK2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 06:28:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:57516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0GaK2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 06:28:14 -0400
Message-ID: <4C53FAA7.60903@kernel.org>
Date: Sat, 31 Jul 2010 12:27:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 1/2] workqueue: mark init_workqueues() as early_initcall()
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com> <20100730165522.22dc982b.akpm@linux-foundation.org>
In-Reply-To: <20100730165522.22dc982b.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 31 Jul 2010 10:27:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/31/2010 01:55 AM, Andrew Morton wrote:
> On Fri, 30 Jul 2010 14:57:37 -0700
> for_each_gcwq_cpu(), for_each_online_gcwq_cpu() and for_each_cwq_cpu()
> make me cry.

Yeah, those are new additions for unbound workqueue support and I
should have added comments there.  Will do so.

Thanks.

-- 
tejun
