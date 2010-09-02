Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0IBCdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:33:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:7506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0IBCdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,307,1280732400"; 
   d="scan'208";a="834094079"
Subject: Re: [PATCH 2/2][Patch-next -v2] ACPI, APEI, HEST Fix the
 unsuitable usage of platform_data.
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: APEI-lenb <lenb@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4C7F0C94.8090802@np.css.fujitsu.com>
References: <4C7F0C94.8090802@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 10:33:40 +0800
Message-ID: <1283394820.13175.48.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 10:31 +0800, Jin Dongming wrote:
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


