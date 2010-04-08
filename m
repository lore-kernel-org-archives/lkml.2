Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab0DHSB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:01:59 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:58526 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab0DHSB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:01:58 -0400
Message-ID: <4BBE1957.3050800@oracle.com>
Date: Thu, 08 Apr 2010 10:58:47 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Jesse Brandeburg <jesse.brandeburg@gmail.com>, David.Woodhouse@intel.com,
       len.brown@intel.com, chrisw@sous-sol.org, suresh.b.siddha@intel.com,
       mingo@elte.hu, yu.zhao@intel.com, fenghua.yu@intel.com,
       weidong@intel.com, iommu@lists.linux-foundation.org,
       gregory.v.rose@intel.com,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] intel-iommu: don't call domain_exit if can not attach
  with iommu
References: <4BA42A95.4000301@kernel.org>	<4BA4A19C.1010607@kernel.org>	<4807377b1003291045r601cc1dx4d2a567f03ab6df6@mail.gmail.com> <20100408094953.35f4b85a@virtuousgeek.org>
In-Reply-To: <20100408094953.35f4b85a@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BBE19FA.0048:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 09:49 AM, Jesse Barnes wrote:
> Hopefully Ingo or David have picked this one up already?
> 
No.

If you like, I could resend some other small clean patches for intel iommu/dmar to you.

Thanks

Yinghai
