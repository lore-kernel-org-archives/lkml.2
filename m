Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1JTJt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:49:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30407 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab1JTJt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:49:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6504"; a="129218050"
X-IronPort-AV: E=Sophos;i="4.69,375,1315206000"; 
   d="scan'208";a="169848467"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
Thread-Topic: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
Thread-Index: AQHMjvQO9EGPKqVzTkOxaT8937sMf5WFYLyA//+Sl8CAAHhsAP//jNYA
Date: Thu, 20 Oct 2011 09:48:39 +0000
Message-ID: <6349D7A510622448B1BA0967850A8438011CC2A0@nasanexd02d.na.qualcomm.com>
References: <1319093184-19696-1-git-send-email-cloud.ren@Atheros.com>
	<20111020.044541.970282389722164761.davem@davemloft.net>
	<6349D7A510622448B1BA0967850A8438011CC21D@nasanexd02d.na.qualcomm.com>
 <20111020.052506.373437241768777548.davem@davemloft.net>
In-Reply-To: <20111020.052506.373437241768777548.davem@davemloft.net>
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


>From: "Ren, Cloud" <cjren@qca.qualcomm.com>
>Date: Thu, 20 Oct 2011 09:23:07 +0000
>
>> As you saw, should I do the two following steps?
>> 1. I firstly try to submit code to linux-staging.git.
>> 2. After the driver have been accepted by  linux-staging.git, I submit to net-
>next.git again.
>
>You submit and get it into staging so that it can sit there for some time and get
>reviewed and improved by others.
>
>One doesn't submit directly to net-next right after it gets into staging, staging
>is a place where your driver lives while it still smelly funky and needs more
>work.

The driver will support the next generation NICs of Atheros. Meanwhile, the driver can 
also have better optimization for AR8131 and AR8151 than atl1c. For some reason, we 
don't plan to patch atl1c driver to support our new NIC, such as AR8161. So I hope the driver
can stay in net-next in the end. Of course, I will be responsible for modify source code and 
let it match kernel requirements.
