Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0FONv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:51:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34987 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab0FONvz (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Jun 2010 09:51:55 -0400
Date: Tue, 15 Jun 2010 01:10:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 02/12] irq: make spurious poll timer per desc
Message-ID: <20100615051027.GA8073@phenom.dumpdata.com>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
 <1276443098-20653-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276443098-20653-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C1784F6.012C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -169,6 +170,7 @@ struct irq_2_iommu;
>   * @pending_mask:	pending rebalanced interrupts
>   * @threads_active:	number of irqaction threads currently running
>   * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
> + * @poll_timer:		timer for IRQ polling

I looked over the patches and they all look good to my eyes.

The only thing that looked out of place was the above comment.
Would it make sense to move the comment one tab to the left?

>   * @dir:		/proc/irq/ procfs entry
>   * @name:		flow handler name for /proc/interrupts output
>   */
