Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2JBLdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:33:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:56063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2JBLdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:33:32 -0400
Message-ID: <1349177594.7780.25.camel@twins>
Subject: Re: [PATCH v2 0/2] Update sched_domains_numa_masks when new cpus
 are onlined.
From: Peter Zijlstra <peterz@infradead.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: srivatsa.bhat@linux.vnet.ibm.com, mingo@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org
Date: Tue, 02 Oct 2012 13:33:14 +0200
In-Reply-To: <1348578751-16904-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1348578751-16904-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 21:12 +0800, Tang Chen wrote:

> Tang Chen (2):
>   Ensure sched_domains_numa_levels safe in other functions.
>   Update sched_domains_numa_masks when new cpus are onlined.
> 
>  kernel/sched/core.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)

Thanks!
