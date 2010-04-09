Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006Ab0DIARP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:17:15 -0400
Received: from sous-sol.org ([216.99.217.87]:53049 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758086Ab0DIARN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:17:13 -0400
Date: Thu, 8 Apr 2010 17:16:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, David.Woodhouse@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] pci/dmar/sriov: use physfn to search drhd for VF
Message-ID: <20100409001626.GJ3168@sequoia.sous-sol.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
 <1270753107-15881-5-git-send-email-yinghai@kernel.org>
 <adawrwhwyiq.fsf@roland-alpha.cisco.com>
 <4BBE4209.3080900@oracle.com>
 <20100408232437.GG3168@sequoia.sous-sol.org>
 <4BBE6FDB.9010805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBE6FDB.9010805@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai (yinghai.lu@oracle.com) wrote:
> Subject: [PATCH] pci/dmar/sriov: use physfn to search drhd for VF
> 
> When virtfn is used, we should use physfn to find correct drhd
> 
> -v2: add pci_physfn() Suggested by Roland Dreier <rdreier@cisco.com>
>      do can remove ifdef in dmar.c
> -v3: Chris pointed out we need that for dma_find_matched_atsr_unit too
>      also change dmar_pci_device_match() static
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Roland Dreier <rdreier@cisco.com>

Looks good

Acked-by: Chris Wright <chrisw@sous-sol.org>
