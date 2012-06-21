Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2FUGym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:54:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:53951 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982Ab2FUGyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:54:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168363671"
From: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Cihula, Joseph" <joseph.cihula@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>,
        "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>,
        "srajiv@linux.vnet.ibm.com" <srajiv@linux.vnet.ibm.com>,
        "m.selhorst@sirrix.com" <m.selhorst@sirrix.com>,
        "shpedoikal@gmail.com" <shpedoikal@gmail.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Subject: [PATCH V3 0/2] Add PPI support in tpm driver
Thread-Topic: [PATCH V3 0/2] Add PPI support in tpm driver
Thread-Index: Ac1PerjBQjzE+LB6Q6aEpYYGzU86Yw==
Date: Thu, 21 Jun 2012 06:54:37 +0000
Message-ID: <1340203949.24516.0.camel@localhost>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.48.101]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5L6sla9009367

The series of patches add PPI support in linux kernel.

The Physical Presence Interface enables the OS and the BIOS to cooperate to
provide a simple and straightforward platform user experience for
administering the TPM without sacrificing security.

PATCH 1: drivers: Add PPI support in tpm driver
PATCH 2: Documentation: sysfs for physical presence interface
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
