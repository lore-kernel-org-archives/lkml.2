Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1HXGxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:53:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:59149 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1HXGxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:53:03 -0400
Message-ID: <4E549E9B.7080004@kernel.org>
Date: Tue, 23 Aug 2011 23:47:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
        youquan.song@intel.com, joerg.roedel@amd.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] iommu: rename the DMAR and INTR_REMAP config options
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com> <20110824001456.558630224@sbsiddha-desk.sc.intel.com>
In-Reply-To: <20110824001456.558630224@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E549EA8.003E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 05:05 PM, Suresh Siddha wrote:
> Change the CONFIG_DMAR to CONFIG_INTEL_IOMMU to be consistent with the other
> IOMMU options.
> 
> Rename the CONFIG_INTR_REMAP to CONFIG_IRQ_REMAP to match the irq
> subsystem name.
> 
> And define the CONFIG_DMAR_TABLE for the common ACPI DMAR routines
> shared by both CONFIG_INTEL_IOMMU and CONFIG_IRQ_REMAP.
> 

is there something like IRQ_REMAP from AMD?

Yinghai
