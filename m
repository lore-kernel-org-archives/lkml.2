Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1DUWOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:14:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:55182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1DUWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:13:59 -0400
Subject: Re: [PATCH RESEND 2] intel_iommu: disable all VT-d PMRs when TXT
 launched
From: David Woodhouse <dwmw2@infradead.org>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, "Wei, Gang" <gang.wei@intel.com>
In-Reply-To: <4DB0AB00.80105@intel.com>
References: <4D879328.1080006@intel.com>  <4DB0AB00.80105@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 23:13:55 +0100
Message-ID: <1303424035.13521.12.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 15:09 -0700, Joseph Cihula wrote:
> linux-2.6.38-rc3-vtd/drivers/pci/intel-iommu.c
> --- linux-2.6.38-rc3/drivers/pci/intel-iommu.c  2011-01-31
> 19:05:49.000000000 -0800
> +++ linux-2.6.38-rc3-vtd/drivers/pci/intel-iommu.c      2011-02-18
> 15:42:36.778301210 -0800
> @@ -1299,7 +1299,7 @@ static void iommu_detach_domain(struct d 

And in all these resends you haven't thought to actually try to *apply*
the patch and see if you're sending something that doesn't even work?

It was fixed up and merged into Linus' tree before your latest resend,
btw.

-- 
dwmw2

