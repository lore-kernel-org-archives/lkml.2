Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2LVP2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 10:28:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:33933 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab2LVP2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 10:28:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,336,1355126400"; 
   d="scan'208";a="265957070"
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: linux-wimax <linux-wimax@intel.com>,
        "wimax@linuxwimax.org" <wimax@linuxwimax.org>
Subject: RE: [PATCH 20/25] wimax/i2400m: fix i2400m->wake_tx_skb handling
Thread-Topic: [PATCH 20/25] wimax/i2400m: fix i2400m->wake_tx_skb handling
Thread-Index: AQHN3+fc9vSZFmyU1UW2z80R1XQ2Npgk8Zvw
Date: Sat, 22 Dec 2012 15:28:03 +0000
Message-ID: <3A78FAA0EC814D4B8ECC99B3AB32B3320B15EC95@fmsmsx110.amr.corp.intel.com>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-21-git-send-email-tj@kernel.org>
In-Reply-To: <1356141435-17340-21-git-send-email-tj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of Tejun Heo
0m: fix i2400m->wake_tx_skb handling
> 
...
> 
> Only compile tested.

I don't have access to hardware to test this--might want to contact Dan Williams,
as he has been more actively using it.

