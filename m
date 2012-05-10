Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab2EJPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:20:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:18000 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759005Ab2EJPUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:20:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98561246"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] Xen physical cpus interface
Thread-Topic: [PATCH 3/3] Xen physical cpus interface
Thread-Index: AQHNLr1B1b8pDRiwSFiwkpXixs4X8JbDIYNQ
Date: Thu, 10 May 2012 15:20:34 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351B5A1A@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
 <20120420192439.GA32170@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351B5807@SHSMSX101.ccr.corp.intel.com>
 <20120510145745.GO26152@phenom.dumpdata.com>
In-Reply-To: <20120510145745.GO26152@phenom.dumpdata.com>
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

Just notice your reply (so quick :)

Agree and will update later, except 1 concern below.

Konrad Rzeszutek Wilk wrote:
>> 
>> Hmm, it's good if it's convenient to do it automatically via
>> dev->release. 
>> However, dev container (pcpu) would be free at some other error
>> cases, so I prefer do it 'manually'. 
> 
> You could also call pcpu_release(..) to do it manually.
> 

that means kfree(pcpu) would be done twice at some error cases, do you think it really good?

Thanks,
Jinsong