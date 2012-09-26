Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2IZMi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:38:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab2IZMix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:38:53 -0400
Date: Wed, 26 Sep 2012 14:38:25 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -tip 0/5] x86, MSI, AHCI: Support multiple MSIs
Message-ID: <20120926123824.GB7123@dhcp-26-207.brq.redhat.com>
References: <cover.1346653435.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1346653435.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 11:16:55AM +0200, Alexander Gordeev wrote:
>   5/5:	based on Jeff's comments:
> 
> 	- AHCI specific code moved from libata-core.c to libahci.c;
> 
> 	- the host-wide lock concern addressed - ahci_interrupt() handler
> 	  split in two parts: ahci_hw_interrupt() hardware context handler
> 	  and ahci_thread_fn() threaded handler;
> 
> 	- host->lock statistics attached;

Hi Jeff,

Would you please comment on the changes and numbers?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
