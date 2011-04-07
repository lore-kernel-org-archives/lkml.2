Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1DGSgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:36:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:62828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1DGSgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,317,1299484800"; 
   d="scan'208";a="625126301"
Date: Thu, 7 Apr 2011 11:36:38 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Feng Tang <feng.tang@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <hpa@zytor.com>, <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, <arjan@linux.intel.com>,
        <alan@linux.intel.com>
Subject: Re: [PATCH] x86/mrst: move sfi timer irqs after gsi_top
Message-ID: <20110407113638.59497927@jacob-laptop>
In-Reply-To: <20110407093021.1a778324@feng-i7>
References: <1301962175-4336-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<BANLkTi=VZCtNnx2dK9hgWmUVGb8ntMrxuw@mail.gmail.com>
	<20110407093021.1a778324@feng-i7>
Organization: OTC
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011 09:30:21 +0800
Feng Tang <feng.tang@intel.com> wrote:

> Hi Jacob,
> 
> The mrst vrtc driver has the similar irq number problem in 2.6.39-rc2,
> how about the following patch to solve it in ioapic code.
Just dug up the old thread in https://lkml.org/lkml/2010/6/10/70. I
actually have been through this before, I just sent out another patch
for this as suggested by Eric.

This patch is withdrawn now.

Thanks,

Jacob
