Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2EUNE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:04:57 -0400
Received: from 8bytes.org ([85.214.48.195]:35354 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab2EUNEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:04:55 -0400
Date: Mon, 21 May 2012 15:04:51 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 1/2] resources: set type of new resource returned by
 __request_region()
Message-ID: <20120521130451.GK2313@8bytes.org>
References: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
 <20120518231832.31187.10630.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518231832.31187.10630.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 21 15:04:53 2012
X-DSPAM-Confidence: 0.9986
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fba3d7528385598017348
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 05:18:32PM -0600, Bjorn Helgaas wrote:
> Previously we returned a new struct resource with only IORESOURCE_BUSY
> set (and possibly IORESOURCE_MUXED or IORESOURCE_EXCLUSIVE), but no
> MEM/IO/etc. bits set.  The new resource should inherit the type of
> its parent.

Should it? What about IORESOURCE_WINDOW for example? Any particular
reason for this change to the interface of the __request_region()
function?


	Joerg


