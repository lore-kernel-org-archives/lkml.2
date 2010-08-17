Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab0HQESX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:18:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:1839 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab0HQESV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,380,1278313200"; 
   d="scan'208";a="545987681"
Subject: Re: [PATCH 4/4] [Patch-next] ACPI, APEI, HEST Fix the unsuitable
 usage of platform_data.
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
In-Reply-To: <4C69FB32.4000802@np.css.fujitsu.com>
References: <4C69DEA5.1020902@np.css.fujitsu.com>
	 <1282009188.2744.1498.camel@yhuang-dev>
	 <4C69FB32.4000802@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 12:18:18 +0800
Message-ID: <1282018698.2744.1508.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 11:00 +0800, Jin Dongming wrote:
> > Why not use platform_device_add_data?
> Here what should be done is to transport the pointer of hest_hdr to platform_data,
> so I think that it could be done successfully by allocating 8byte of memory.
> If the platform_device_add_data() is used, the more memory will be allocated. 
> 
> So I think this method is better than using platform_device_add_data().

You can specify allocation size for platform_device_add_data(), so no
more memory will be allocated.

Best Regards,
Huang Ying


