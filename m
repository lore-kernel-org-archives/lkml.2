Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1EYJQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:16:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52993 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1EYJQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:16:52 -0400
Date: Wed, 25 May 2011 11:16:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Song, Youquan" <youquan.song@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: linux-next: manual merge of the dwmw2-iommu tree with Linus' tree
Message-ID: <20110525091636.GC28500@elte.hu>
References: <20110525130004.150c054f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525130004.150c054f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi David,
> 
> Today's linux-next merge of the dwmw2-iommu tree got a conflict in
> arch/x86/kernel/apic/apic.c between commit 31dce14a3269 ("x86, ioapic:
> Use ioapic_saved_data while enabling intr-remapping") from Linus' tree and
> commit 6a87c5ec6463 ("intel-iommu: enable x2apic opt out") from the
> dwmw2-iommu tree.

David, please do not modify arch/x86/kernel/apic/apic.c but send such 
patches to the x86 maintainers!

That particular change was still under discussion and i'm not at all 
sure we want to do it like that. So please repost the latest version.

Thanks,

	Ingo
