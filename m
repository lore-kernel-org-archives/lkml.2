Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192Ab0HFKV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:21:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:19526 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761147Ab0HFKVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:21:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,327,1278313200"; 
   d="scan'208";a="542488600"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Dan Carpenter <error27@gmail.com>, Julia Lawall <julia@diku.dk>
CC: "Latif, Faisal" <faisal.latif@intel.com>,
        Roland Dreier <rolandd@cisco.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Fri, 6 Aug 2010 03:21:31 -0700
Subject: RE: [PATCH 4/42 v2] drivers/infiniband/hw/nes: Adjust confusing if
 indentation
Thread-Topic: [PATCH 4/42 v2] drivers/infiniband/hw/nes: Adjust confusing if
 indentation
Thread-Index: Acs0+Mx19U8Mv8dCR6SP2YfTHHBoaAAV5sDw
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9049F35CB95@azsmsx506.amr.corp.intel.com>
References: <Pine.LNX.4.64.1008052217430.31692@ask.diku.dk>
 <20100805234831.GK9031@bicker>
In-Reply-To: <20100805234831.GK9031@bicker>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the white space is meant to look like this.  I did look at
> whether the "sq_cqes = 0;" should only be done if netif_queue_stopped().
> In the end I decided this was what was intended, but it would be
> better if someone more familiar with the code reviewed it.
> 
> Reported-by: Julia Lawall <julia@diku.dk>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> v2: changed different indents

Looks to me.  Thanks for the patch.

Acked-by: Chien Tung <chien.tin.tung@intel.com>

Chien




