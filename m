Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2KQM1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:27:47 -0500
Received: from 8bytes.org ([85.214.48.195]:55107 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2KQM1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:27:46 -0500
Date: Sat, 17 Nov 2012 13:27:43 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, prometheanfire@gentoo.org,
        cardoe@gentoo.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, mthode@mthode.org, ddutile@redhat.com,
        bhelgaas@google.com, dwmw2@infradead.org
Subject: Re: [PATCH] intel-iommu: Fix lookup in add device
Message-ID: <20121117122743.GB11220@8bytes.org>
References: <20121113172144.6783.37724.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113172144.6783.37724.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Nov 17 13:27:45 2012
X-DSPAM-Confidence: 0.9984
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50a782c122971381013324
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 10:22:03AM -0700, Alex Williamson wrote:
> We can't assume this device exists, fall back to the bridge itself.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Tested-by: Matthew Thode <prometheanfire@gentoo.org>
> Cc: stable@vger.kernel.org

Applied to iommu/fixes, thanks.

