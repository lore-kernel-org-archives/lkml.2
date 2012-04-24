Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab2DXKMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:12:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:53906 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625Ab2DXKMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:12:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="134588548"
Date: Tue, 24 Apr 2012 13:13:34 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 2/3] gpio: langwell: allocate IRQ descriptors dynamically
 for SPARSE_IRQ
Message-ID: <20120424101334.GA16266@intel.com>
References: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com>
 <1333617317-28437-2-git-send-email-mika.westerberg@linux.intel.com>
 <20120406043414.3B8FF3E0DD7@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120406043414.3B8FF3E0DD7@localhost>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 09:34:14PM -0700, Grant Likely wrote:
> On Thu,  5 Apr 2012 12:15:16 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> > Since x86 is using SPARSE_IRQ by default nowadays it means that we need to
> > allocate IRQ descriptors dynamically using irq_alloc_descs() otherwise the
> > genirq code fails to convert our irq numbers to suitable descriptors.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Applied, thakns.
> 

Grant, is there any change getting this particular patch merged for 3.4 as
well? Without this the driver will fail on 3.4.
