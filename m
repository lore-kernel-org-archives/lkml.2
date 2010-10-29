Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab0J2KEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:04:15 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26468 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab0J2KEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:04:12 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275dhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0LB1QM1-01-A9U-02
X-M-MSG: 
Date: Fri, 29 Oct 2010 12:03:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Tejun Heo <tj@kernel.org>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] oprofile: don't use flush_scheduled_work()
Message-ID: <20101029100338.GE5969@erda.amd.com>
References: <4CB85C4C.6080806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CB85C4C.6080806@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.10 09:51:08, Tejun Heo wrote:
> flush_scheduled_work() is deprecated and scheduled to be removed.
> sync_stop() currently cancels cpu_buffer works inside buffer_mutex and
> flushes the system workqueue outside.  Instead, split end_cpu_work()
> into two parts - stopping further work enqueues and flushing works -
> and do the former inside buffer_mutex and latter outside.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Patch applied to oprofile/urgent. Thanks Tejun.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

