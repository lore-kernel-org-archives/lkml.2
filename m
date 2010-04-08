Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab0DHSNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:13:42 -0400
Received: from sous-sol.org ([216.99.217.87]:58972 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758897Ab0DHSNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:13:41 -0400
Date: Thu, 8 Apr 2010 11:13:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       David.Woodhouse@intel.com, len.brown@intel.com,
       suresh.b.siddha@intel.com, mingo@elte.hu, yu.zhao@intel.com,
       fenghua.yu@intel.com, weidong@intel.com,
       iommu@lists.linux-foundation.org, gregory.v.rose@intel.com,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] intel-iommu: don't call domain_exit if can not attach
 with iommu
Message-ID: <20100408181300.GB3168@sequoia.sous-sol.org>
References: <4BA42A95.4000301@kernel.org>
 <4BA4A19C.1010607@kernel.org>
 <4807377b1003291045r601cc1dx4d2a567f03ab6df6@mail.gmail.com>
 <20100408094953.35f4b85a@virtuousgeek.org>
 <4BBE1957.3050800@oracle.com>
 <20100408180409.GA3168@sequoia.sous-sol.org>
 <4BBE1B22.9070502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBE1B22.9070502@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai (yinghai.lu@oracle.com) wrote:
> On 04/08/2010 11:04 AM, Chris Wright wrote:
> > * Yinghai (yinghai.lu@oracle.com) wrote:
> >> On 04/08/2010 09:49 AM, Jesse Barnes wrote:
> >>> Hopefully Ingo or David have picked this one up already?
> >>>
> >> No.
> >>
> >> If you like, I could resend some other small clean patches for intel iommu/dmar to you.
> > 
> > Please do.  (Also, I could not reproduce the issue you saw).
> 
> Will do that
> 
> you may need 8 or more intel 10g pcie cards, with ixgbe_vf enabled.

cards or VFs?

IOW, one dual port card can do something like 126 VFs + 2 PFs

thanks,
-chris
