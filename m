Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1JZXEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:04:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:31685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1JZXEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:04:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,412,1315206000"; 
   d="scan'208";a="82789810"
From: "Hebenstreit, Michael" <michael.hebenstreit@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: FATAL: kenrel too old - message
Thread-Topic: FATAL: kenrel too old - message
Thread-Index: AcyUMwwhZL8k47boSmyAsZKq15oy7Q==
Date: Wed, 26 Oct 2011 23:04:04 +0000
Message-ID: <B4E6F7EB08816A4692C7420D7E8F8CBD16EC546E@ORSMSX101.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone explain me why even an ldd on a dynamic executable gives a "kernel too old"? I understand that linking to a gcc that does not support the kernel causes this problem at runtime, but why does ldd fail? Are there other ways to diagnose this?

Thanks
Michael


$ file ./ac_knc
./ac_knc: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.34, not stripped
                
$ ./ac_knc
FATAL: kernel too old

$ ldd ./ac_knc
FATAL: kernel too old



------------------------------------------------------------------------
Michael Hebenstreit                 Senior Cluster Architect
Intel Corporation                   Software and Services Group/HTE
2800 N Center Dr, DP3-307           Tel.:   +1 253 371 3144
WA 98327, DuPont           
UNITED STATES                       E-mail: michael.hebenstreit@intel.com
