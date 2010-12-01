Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0LAIxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:53:49 -0500
Received: from sous-sol.org ([216.99.217.87]:49866 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753040Ab0LAIxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:53:49 -0500
Date: Wed, 1 Dec 2010 00:52:52 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@kernel.org
Subject: Re: [patch 4/4] vt-d: handle previous faults after enabling fault
 handling
Message-ID: <20101201085252.GO10050@sequoia.sous-sol.org>
References: <20101201062225.292364637@intel.com>
 <20101201062244.630417138@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201062244.630417138@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha (suresh.b.siddha@intel.com) wrote:
> Fault handling is getting enabled after enabling the interrupt-remapping (as
> the success of interrupt-remapping can affect the apic mode and hence the
> fault handling mode).
> 
> Hence there can potentially be some faults between the window of enabling
> interrupt-remapping in the vt-d and the fault-handling of the vt-d units.
> 
> Handle any previous faults after enabling the vt-d fault handling.
> 
> For v2.6.38 cleanup, need to check if we can remove the dmar_fault() in the
> enable_intr_remapping() and see if we can enable fault handling along with
> enabling intr-remapping.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>
