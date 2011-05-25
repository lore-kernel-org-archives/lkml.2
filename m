Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1EYU7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:59:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:43366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1EYU7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:59:17 -0400
Subject: Re: linux-next: manual merge of the dwmw2-iommu tree with Linus'
 tree
From: David Woodhouse <dwmw2@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Song, Youquan" <youquan.song@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 25 May 2011 21:59:06 +0100
In-Reply-To: <20110525130004.150c054f.sfr@canb.auug.org.au>
References: <20110525130004.150c054f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306357154.2029.12.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 13:00 +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the dwmw2-iommu tree got a conflict in
> arch/x86/kernel/apic/apic.c between commit 31dce14a3269 ("x86, ioapic:
> Use ioapic_saved_data while enabling intr-remapping") from Linus' tree and
> commit 6a87c5ec6463 ("intel-iommu: enable x2apic opt out") from the
> dwmw2-iommu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. 

Offending patch dropped.

The machine hosting git.infradead.org is going down shortly, and will be
coming up in a new home tomorrow morning Boston time (EDT/GMT-5). Please
could you use this git repository instead for the iommu tree, for
"tonight's" linux-next:
    git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/iommu-2.6.git

(or ssh://master.kernel.org/pub/scm/linux/kernel/git/dwmw2/iommu-2.6.git
if it hasn't propagated to the mirrors in time)

Thanks.

The mtd tree hasn't changed in the last day, so no need to use a
separate URL for that; the last pull is fine, right?

-- 
dwmw2

