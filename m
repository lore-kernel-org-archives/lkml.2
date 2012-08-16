Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2HPPum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2HPPul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:50:41 -0400
Date: Thu, 16 Aug 2012 17:50:21 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 0/3] x86, MSI: Support multiple MSIs in presense of IRQ
 remapping
Message-ID: <20120816155020.GH2246@dhcp-26-207.brq.redhat.com>
References: <cover.1343732015.git.agordeev@redhat.com>
 <1343769169.2041.10.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343769169.2041.10.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:12:49PM -0700, Suresh Siddha wrote:
> On Tue, 2012-07-31 at 13:41 +0200, Alexander Gordeev wrote:
> So while I am ok with the proposed changes, I will hold off acking until
> I see the corresponding driver changes (using pci_enable_msi_block()
> etc) that take advantage of these changes ;)
> 
> Did you have a specific device in mind and are the driver changes
> coming?

Hi Suresh,

I reposted the series + AHCI driver update.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
