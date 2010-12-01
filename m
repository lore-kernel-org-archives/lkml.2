Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0LAIxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:53:16 -0500
Received: from sous-sol.org ([216.99.217.87]:49855 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753129Ab0LAIxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:53:14 -0500
Date: Wed, 1 Dec 2010 00:52:44 -0800
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
Subject: Re: [patch 2/4] x86, vtd: fix the vt-d fault handling irq migration
 in the x2apic mode
Message-ID: <20101201085244.GN10050@sequoia.sous-sol.org>
References: <20101201062225.292364637@intel.com>
 <20101201062244.447287381@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201062244.447287381@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha (suresh.b.siddha@intel.com) wrote:
> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Subject: x86, vtd: fix the vt-d fault handling irq migration in the x2apic mode
> 
> In x2apic mode, we need to set the upper address register of the fault
> handling interrupt register of the vt-d hardware. Without this
> irq migration of the vt-d fault handling interrupt is broken.
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Looks correct, I didn't have a chance to test this patch.

Acked-by: Chris Wright <chrisw@sous-sol.org>
