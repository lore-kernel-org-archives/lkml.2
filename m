Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab2EWDeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:34:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:32068 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab2EWDeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:34:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103152556"
From: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        "srajiv@linux.vnet.ibm.com" <srajiv@linux.vnet.ibm.com>,
        "m.selhorst@sirrix.com" <m.selhorst@sirrix.com>,
        "shpedoikal@gmail.com" <shpedoikal@gmail.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "Cihula, Joseph" <joseph.cihula@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: [PATCH 0/2] Add PPI support in tpm driver
Thread-Topic: [PATCH 0/2] Add PPI support in tpm driver
Thread-Index: Ac04lOMuVHl960DvSdijr+KKBRm47Q==
Date: Wed, 23 May 2012 03:33:58 +0000
Message-ID: <953B7F5DA8C0F44CBD2621D8763F4F6005F797@SHSMSX101.ccr.corp.intel.com>
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

The series of patches add PPI support in linux kernel.

The Physical Presence Interface enables the OS and the BIOS to cooperate to provide a simple and straightforward platform user experience for administering the TPM without sacrificing security.

PATCH 1: drivers: Add PPI support in tpm driver
PATCH 2: Documentation: sysfs for physical presence interface
