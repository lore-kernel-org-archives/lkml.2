Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab2HIXvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:51:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:45920 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab2HIXvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,743,1336374000"; 
   d="scan'208";a="132170496"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Masanari Iida <standby24x7@gmail.com>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "roland@kernel.org" <roland@kernel.org>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>
Subject: RE: [PATCH] [trivial] infiniband: Fix typo in infiniband driver
Thread-Topic: [PATCH] [trivial] infiniband: Fix typo in infiniband driver
Thread-Index: AQHNdocQcZNZqPGHg0a+XxkA50lKApdSJknQ
Date: Thu, 9 Aug 2012 23:51:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A7D419@ORSMSX101.amr.corp.intel.com>
References: <1344555100-3992-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1344555100-3992-1-git-send-email-standby24x7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c
> b/drivers/infiniband/hw/amso1100/c2_rnic.c
> index 8c81992..b80867e 100644
> --- a/drivers/infiniband/hw/amso1100/c2_rnic.c
> +++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
> @@ -439,7 +439,7 @@ static int c2_rnic_close(struct c2_dev *c2dev)
> 
>  /*
>   * Called by c2_probe to initialize the RNIC. This principally
> - * involves initalizing the various limits and resouce pools that
> + * involves initalizing the various limits and resource pools that

while we're here, can we fix initializing too?  thanks

