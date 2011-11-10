Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453Ab1KJNKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:10:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934318Ab1KJNKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:10:47 -0500
Date: Thu, 10 Nov 2011 14:09:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Yu Zhao <yu.zhao@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Oct 25 (pci/ats.c)
Message-ID: <20111110130901.GA32026@elte.hu>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
 <4EA85353.4060101@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA85353.4060101@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 10/25/11 02:36, Stephen Rothwell wrote:
> > Hi all,
> 
> 
> When CONFIG_PCI_IOV is not enabled:
> (probably because PCI_PRI selects PCI_ATS even when PCI_IOV is not
> enabled)
> 
> drivers/pci/ats.c:37:5: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:44:11: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:45:5: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:55:5: error: redefinition of 'pci_enable_ats'
> drivers/pci/ats.c:60:2: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:60:2: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:66:52: error: 'struct pci_dev' has no member named 'physfn'
> drivers/pci/ats.c:68:3: error: 'struct pci_dev' has no member named 'sriov'
> drivers/pci/ats.c:69:11: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:70:13: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:75:8: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:76:21: error: 'struct pci_dev' has no member named 'sriov'
> drivers/pci/ats.c:90:32: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:92:5: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:102:6: error: redefinition of 'pci_disable_ats'
> drivers/pci/ats.c:106:2: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:106:2: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:108:31: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:110:32: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:112:5: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:115:52: error: 'struct pci_dev' has no member named 'physfn'
> drivers/pci/ats.c:117:3: error: 'struct pci_dev' has no member named 'sriov'
> drivers/pci/ats.c:118:7: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:119:12: error: 'struct pci_dev' has no member named 'ats'
> drivers/pci/ats.c:121:21: error: 'struct pci_dev' has no member named 'sriov'
> drivers/pci/ats.c:141:5: error: redefinition of 'pci_ats_queue_depth'
> drivers/pci/ats.c:149:9: error: 'struct pci_dev' has no member named 'ats'
> next-2011-1025/drivers/pci/ats.c:150:13: error: 'struct pci_dev' has no member named 'ats'

This build failure is still present upstream, in v3.2-rc1 and later 
kernels.

Thanks,

	Ingo
