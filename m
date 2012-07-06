Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab2GFGbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:31:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:2590 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab2GFGbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:31:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="189076636"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Roland Dreier <roland@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the infiniband tree
Thread-Topic: linux-next: build failure after merge of the infiniband tree
Thread-Index: AQHNWyAbnVVLR8zONE275K7suC6c/pccFlcA//+1CnA=
Date: Fri, 6 Jul 2012 06:31:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A4FE1B@ORSMSX101.amr.corp.intel.com>
References: <20120706123555.949d8efb4de5c4df18fb1ec0@canb.auug.org.au>
 <CAL1RGDW+3Q86QUp-aaWajT8nLK_7hQuCbxeE4q9He=aGdAMX6Q@mail.gmail.com>
In-Reply-To: <CAL1RGDW+3Q86QUp-aaWajT8nLK_7hQuCbxeE4q9He=aGdAMX6Q@mail.gmail.com>
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

> Thanks, fixed with a "#if IS_ENABLED(CONFIG_IPV6)" around the code
> that touches ipv6... Sean, let me know if more is required.

The fix-up looks to be complete.  Thanks
