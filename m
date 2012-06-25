Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2FYFc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 01:32:27 -0400
Received: from linux-sh.org ([111.68.239.195]:58998 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab2FYFc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 01:32:26 -0400
Date: Mon, 25 Jun 2012 14:31:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sundar Iyer <sundar.iyer@intel.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        german.monroy@intel.com
Subject: Re: [PATCH v3 1/1] x86/irq: handle chained interrupts during IRQ
 migration
Message-ID: <20120625053156.GB24033@linux-sh.org>
References: <1340596507-12702-1-git-send-email-sundar.iyer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340596507-12702-1-git-send-email-sundar.iyer@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 09:25:07AM +0530, Sundar Iyer wrote:
> Chained interrupt handlers dont have an irqaction and hence are not
> handled during migrating interrupts when some cores go offline.
> 
> Handle this by introducing a irq_is_chained() check which is based
> on the the CHAINED flag being set for such interrupts. fixup_irq()
> can then handle such interrupts and not skip them over.
> 
> Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
> Reviewed-by: Yang, Fei <fei.yang@intel.com>
> Tested-by: Ng, Cheon-woei <cheon-woei.ng@intel.com>

Looks better to me.
