Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0LFVCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:02:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:20521 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab0LFVCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:02:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,307,1288594800"; 
   d="scan'208";a="684467782"
Subject: Re: [patch 1/4] vt-d: quirk for masking vtd spec errors to
 platform error handling logic
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20101206124423.0868b71e@jbarnes-desktop>
References: <20101201062225.292364637@intel.com>
	 <20101201062244.365995600@intel.com>
	 <20101206092749.7f89f3fd@jbarnes-desktop>
	 <1291667190.2675.8.camel@sbsiddha-MOBL3.sc.intel.com>
	 <20101206124423.0868b71e@jbarnes-desktop>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 06 Dec 2010 13:02:12 -0800
Message-Id: <1291669332.2675.23.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 12:44 -0800, Jesse Barnes wrote:
> On Mon, 06 Dec 2010 12:26:30 -0800
> Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > On Mon, 2010-12-06 at 09:27 -0800, Jesse Barnes wrote:
> > > Can we make these registers and bits a bit more self-documenting (i.e.
> > > #defines for both, maybe along with other useful bit definitions for
> > > this reg)? Also, "error" is misspelled as "erorr" above. :)
> > 
> > Thanks for the review. Appended the updated patch. I haven't used
> > #defines for the pci-id's, as the first one (IOH) is used by several
> > chipsets and the second one is not named yet.
> 
> Is there a bug # that should be referenced in the commit log?  Any
> tested-bys to add?

There is no kernel.org bug# but there are multiple bugs with different
OSV's. And hence didn't care to mention to the bug #

Please add:

Reported-by: Max Asbock <masbock@linux.vnet.ibm.com>
Reported-and-tested-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

thanks,
suresh

