Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1LWKVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:21:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:5663 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1LWKVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:21:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="90820928"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Brown, Len" <len.brown@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/10] Linux 3.1.0 Xen RAS rebase
Thread-Topic: [PATCH 00/10] Linux 3.1.0 Xen RAS rebase
Thread-Index: AczBXKB0mag++cqVSzS+PvJp33blKQ==
Date: Fri, 23 Dec 2011 10:21:26 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923359674@SHSMSX101.ccr.corp.intel.com>
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

Recently we did dom0 Xen RAS rebase work, mainly involve xen interface at kernel for following features:
1). mce
2). cpu online/offline
3). cpu hotadd
4). memory hotadd

Basically it rebased from Jeremy's pvops (2.6.32), to Konrad's pvops (3.1.0, branch "devel/acpi-cpufreq.v3")
patch 1: for mcelog logic
patch 2: for dom0 vmce
patch 3: for cpu sysfs and cpu online/offline
patch 4: for cpu hotadd
patch 5: for memory hotadd prepare work
patch 6: for memory hotadd
patch 7: for cpu hotadd prepare work
patch 8: complement cpu hotadd lacked at Konrad's tree
patch 9: update PM logic
patch 10: upate cpu online/offline logic


Thanks,
Jinsong