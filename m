Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2K2AUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:20:03 -0500
Received: from 8bytes.org ([85.214.48.195]:41476 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab2K2AUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:20:00 -0500
Date: Thu, 29 Nov 2012 01:19:54 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH 00/19 v4] Improve IRQ remapping abstraction in x86 core
 code
Message-ID: <20121129001954.GG30633@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
 <20121128212205.GD13915@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128212205.GD13915@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Nov 29 01:19:56 2012
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50b6aa2c22975153712821
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On Wed, Nov 28, 2012 at 04:22:05PM -0500, Konrad Rzeszutek Wilk wrote:

> I looked at the patches and you can also add
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks for your review, I added the line to the patches.

> If you have a git tree I would like to test them as well. Thx.

I rebased to v3.7-rc7 and pushed it to

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git  ioapic-cleanups

(Just pushed, may take some time to hit the mirrors)


Thanks,

	Joerg


