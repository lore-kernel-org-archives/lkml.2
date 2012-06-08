Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702Ab2FHBO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:14:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:26652 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759472Ab2FHBOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:14:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176462661"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: David Miller <davem@davemloft.net>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "guru.anbalagane@oracle.com" <guru.anbalagane@oracle.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "adnan.misherfi@oracle.com" <adnan.misherfi@oracle.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [E1000-devel] [PATCH] e1000e: disable rxhash when try to enable
 jumbo frame also rxhash and rxcsum have enabled
Thread-Topic: [E1000-devel] [PATCH] e1000e: disable rxhash when try to
 enable jumbo frame also rxhash and rxcsum have enabled
Thread-Index: AQHNRRMTaJPCft258ECC6040LRbWF5bwEoeA//+K+wA=
Date: Fri, 8 Jun 2012 01:14:38 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18428445A22@ORSMSX102.amr.corp.intel.com>
References: <4FD15020.7090709@oracle.com>
 <20120607.181143.231727418873766540.davem@davemloft.net>
In-Reply-To: <20120607.181143.231727418873766540.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, June 07, 2012 6:12 PM
> To: joe.jin@oracle.com
> Cc: e1000-devel@lists.sourceforge.net; guru.anbalagane@oracle.com;
> Allan, Bruce W; Brandeburg, Jesse; adnan.misherfi@oracle.com; Ronciak,
> John; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [E1000-devel] [PATCH] e1000e: disable rxhash when try to
> enable jumbo frame also rxhash and rxcsum have enabled
> 
> From: Joe Jin <joe.jin@oracle.com>
> Date: Fri, 08 Jun 2012 09:06:40 +0800
> 
> > Upstream commit 70495a5 check if both rxhash and rxcsum enabled when
> enabling
> > jumbo frames and disallowed all of them enabled at the same time.
> >
> > Since jumbo frame widely be used in real world, so when try to
> enable jumbo
> > frames but rxhash and rxcsum have enabled, change the default
> behavior to
> > disable receive hashing.
> >
> > Signed-off-by: Joe Jin <joe.jin@oracle.com>
> > Signed-off-by: Guru Anbalagane <guru.anbalagane@oracle.com>
> > Acked-by: Adnan Misherfi <adnan.misherfi@oracle.com>
> 
> If I were the Intel developers I would not apply this patch, it sets
> a very bad precedence.
> 
> The tool tells you that the combination you're attempting to use is
> invalid, and the kernel log message tells you exactly why.
> 
> The driver should never automatically change configuration settings
> not actually requested by the user.

I've been working on another patch that removes the issue with disabling
one feature over another altogether, so this patch would be moot.  It will
be pushed to our internal testing organization in the next day or two.

