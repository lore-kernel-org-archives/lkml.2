Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1JSHye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:54:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35614 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1JSHyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:54:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6503"; a="128973832"
X-IronPort-AV: E=Sophos;i="4.69,368,1315206000"; 
   d="scan'208";a="146487652"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
Thread-Topic: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
Thread-Index: AQHMjjOzFppzpiUqeUWg3lcutaYw0pWDS/1A
Date: Wed, 19 Oct 2011 07:53:53 +0000
Message-ID: <6349D7A510622448B1BA0967850A8438011CBAB1@nasanexd02d.na.qualcomm.com>
References: <1319009213-20627-1-git-send-email-cloud.ren@atheros.com>
	<20111019.033324.1233460304204609569.davem@davemloft.net>
	<6349D7A510622448B1BA0967850A8438011CBA5D@nasanexd02d.na.qualcomm.com>
 <20111019.035000.931404890148181821.davem@davemloft.net>
In-Reply-To: <20111019.035000.931404890148181821.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.45.230.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got it. Thanks.

-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Wednesday, October 19, 2011 3:50 PM
To: Ren, Cloud
Cc: Rodriguez, Luis; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161 Ethernet driver

From: "Ren, Cloud" <cjren@qca.qualcomm.com>
Date: Wed, 19 Oct 2011 07:44:02 +0000

> Ok. What logging interfaces can I use? Are they dev_err, dev_info and 
> dev_warn ? thanks

netif_*(), they check netif_msg_*() to see if the particular kind of logging message is enabled or not, and this can be set dynamically if you code your driver to properly set netdev->msg_enable.

Use other drivers as examples.

