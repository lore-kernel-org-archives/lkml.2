Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2JBThs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:37:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:3589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab2JBThq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:37:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,524,1344236400"; 
   d="scan'208";a="199745232"
From: Andi Kleen <andi@firstfloor.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, vgoyal@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de
Subject: Re: [PATCH v2 0/2] Reset PCIe devices to address DMA problem on kdump with iommu
References: <20121002074434.204.47750.sendpatchset@indoh>
Date: Tue, 02 Oct 2012 12:37:44 -0700
In-Reply-To: <20121002074434.204.47750.sendpatchset@indoh> (Takao Indoh's
	message of "Tue, 2 Oct 2012 16:49:56 +0900 (JST)")
Message-ID: <m2mx04wtpz.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takao Indoh <indou.takao@jp.fujitsu.com> writes:

> These patches reset PCIe devices at boot time to address DMA problem on
> kdump with iommu. When "reset_devices" is specified, a hot reset is
> triggered on each PCIe root port and downstream port to reset its
> downstream endpoint.

Great. I've been pondering this for a long time, but you did finally
implement it. I hope this will make kdump a lot more reliable at least
on the systems that support per port reset.

Now the only question is: why make it a option and not default?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
