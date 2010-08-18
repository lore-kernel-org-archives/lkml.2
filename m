Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab0HRESG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 00:18:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:3028 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0HRESE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 00:18:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,225,1280732400"; 
   d="scan'208";a="648771295"
Subject: Re: [PATCH 2/2][Patch-next -v2] ACPI, APEI, HEST Fix the
 unsuitable usage of platform_data.
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
In-Reply-To: <4C6B1FEF.8010509@np.css.fujitsu.com>
References: <4C6B1FEF.8010509@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 12:18:01 +0800
Message-ID: <1282105081.2744.1539.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 07:49 +0800, Jin Dongming wrote:
> platform_data in hest_parse_ghes() is used for saving the address of entry
> information of erst_tab. When the device is failed to be added, platform_data
> will be freed by platform_device_put(). But the value saved in platform_data
> should not be freed here. If it is done, it will make system panic.
> 
> So I think platform_data should save the address of allocated memory
> which saves entry information of erst_tab.
> 
> This patch fixed it and I confirmed it on x86_64 next-tree.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying


