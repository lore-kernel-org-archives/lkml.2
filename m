Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab2EaNBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:01:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:3806 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119Ab2EaNBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149924987"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Thread-Index: AQHNPy1r2PYyBpFJIkSi2OAovIP0Yg==
Date: Thu, 31 May 2012 13:00:58 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FEEAF@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351F44F3@SHSMSX101.ccr.corp.intel.com>
 <20120529133858.GD29157@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351FC452@SHSMSX101.ccr.corp.intel.com>
 <20120530150827.GA12109@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351FC523@SHSMSX101.ccr.corp.intel.com>
 <20120530152948.GD4771@aftab.osrc.amd.com>
In-Reply-To: <20120530152948.GD4771@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Wed, May 30, 2012 at 03:20:03PM +0000, Liu, Jinsong wrote:
>>>> IMO currently there are 2 options:
>>>> 1). use the original approach (implicitly redirect /dev/mcelog to
>>>> xen_mce_chrdev_device) --> what point of this approach do you think
>>>> unreasonable? It just remove a 'static' from native mce code! 2).
>>>> use another /dev/xen-mcelog interface, with another misc minor
>>>> '226' 
>>> 
>>> The 2) is no good.
>>> 
>>> 3) What about moving the corresponding other users (so
>>> threshold_init_device), to be at late_initcall and the mce to be at
>>> late_initcall_sync
>> 
>> I can try, but only if Boris would not jump out.
>> and it can only be tested by Boris at AMD platform :(
> 
> Sure, I'll test it.
> 

Boris,

I have update patches, and they have been tested under baremetal (Intel platform) and xen platform.
So you can test it at AMD platform, and thanks ahead!

Regards,
Jinsong