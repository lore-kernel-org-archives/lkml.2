Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0DIPeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:34:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:38583 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0DIPeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,178,1270450800"; 
   d="scan'208";a="507793395"
Subject: Re: [PATCH 3/6] pci/dmar: remove the noisy print out about
 unmapping
From: David Woodhouse <david.woodhouse@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
In-Reply-To: <1270753107-15881-4-git-send-email-yinghai@kernel.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
	 <1270753107-15881-4-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Fri, 09 Apr 2010 16:34:07 +0100
Message-ID: <1270827247.4478.10439.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 19:58 +0100, Yinghai Lu wrote:
> it seems this one should be removed.
> because map page does not have this annonyed print out.

It's debug output... I'd be more inclined to add it in map_page() than
remove it from here.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

