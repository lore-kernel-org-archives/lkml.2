Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab2HWG45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:56:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57449 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab2HWG4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:56:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6812"; a="226185892"
X-IronPort-AV: E=Sophos;i="4.80,298,1344236400"; 
   d="scan'208";a="160690290"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: "Ren, Cloud" <cjren@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH v2] net: add new QCA alx ethernet driver
Thread-Topic: [PATCH v2] net: add new QCA alx ethernet driver
Thread-Index: AQHNfq/QcigpFEkeAUuvSgE/Sf2tgZdnYDEA//+NnwCAAH58gP//i4Mw
Date: Thu, 23 Aug 2012 06:56:51 +0000
Message-ID: <157393863283F442885425D2C45428562A4F519A@nasanexd02f.na.qualcomm.com>
References: <1345480949-14800-1-git-send-email-cjren@qca.qualcomm.com>
	<20120822.225700.714020017287504609.davem@davemloft.net>
	<157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
 <20120822.234019.1546353507351890178.davem@davemloft.net>
In-Reply-To: <20120822.234019.1546353507351890178.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.48.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Then add a new ethtool operation to support your use case, that's exactly
> what I was telling you to do.
> 
> Did it really not occur to you that you perhaps you should extend existing
> generic facilities to suit your needs instead of creating private facilities that no
> other driver can use?

I'm afraid someone also rejects my request to add such operation to ethtool 
By your same reason.
before adding this interface, we had searched the kernel, marvell driver also 
Uses it, we had thought could be ok.

Of course, we will respect your opinion if it's not appropriated.

Thanks
Xiong
