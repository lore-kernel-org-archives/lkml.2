Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2HHKra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:47:30 -0400
Received: from 8bytes.org ([85.214.48.195]:53611 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2HHKr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:47:29 -0400
Date: Wed, 8 Aug 2012 12:47:25 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/19] Improve IRQ remapping abstraction in x86 core code
Message-ID: <20120808104725.GB4615@8bytes.org>
References: <1344354229-8526-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344354229-8526-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug  8 12:47:26 2012
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 502243be20425645517830
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 07, 2012 at 05:43:30PM +0200, Joerg Roedel wrote:
> For anyone interested in a git-tree I pushed this code to
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git ioapic-cleanups

Fengguang Wu found a couple of build errors. And based on his findings I
found some more which are all fixed now. I pushed the patches with the
fixes to the above mentioned tree.

I will repost the whole series once more comments come in which I work
into the patch-set.

Regards,

	Joerg


