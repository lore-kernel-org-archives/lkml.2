Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab0DHSEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:04:49 -0400
Received: from sous-sol.org ([216.99.217.87]:60764 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758238Ab0DHSEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:04:43 -0400
Date: Thu, 8 Apr 2010 11:04:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       David.Woodhouse@intel.com, len.brown@intel.com, chrisw@sous-sol.org,
       suresh.b.siddha@intel.com, mingo@elte.hu, yu.zhao@intel.com,
       fenghua.yu@intel.com, weidong@intel.com,
       iommu@lists.linux-foundation.org, gregory.v.rose@intel.com,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] intel-iommu: don't call domain_exit if can not attach
 with iommu
Message-ID: <20100408180409.GA3168@sequoia.sous-sol.org>
References: <4BA42A95.4000301@kernel.org>
 <4BA4A19C.1010607@kernel.org>
 <4807377b1003291045r601cc1dx4d2a567f03ab6df6@mail.gmail.com>
 <20100408094953.35f4b85a@virtuousgeek.org>
 <4BBE1957.3050800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBE1957.3050800@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai (yinghai.lu@oracle.com) wrote:
> On 04/08/2010 09:49 AM, Jesse Barnes wrote:
> > Hopefully Ingo or David have picked this one up already?
> > 
> No.
> 
> If you like, I could resend some other small clean patches for intel iommu/dmar to you.

Please do.  (Also, I could not reproduce the issue you saw).

thanks,
-chris
