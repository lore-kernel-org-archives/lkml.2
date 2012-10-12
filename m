Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab2JLNjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:39:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:62285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973Ab2JLNj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:39:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="234078013"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Topic: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Index: AQHNqHeaj1yQox4Me0+UyZJ6nHY31pe1rFyA
Date: Fri, 12 Oct 2012 13:39:26 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A19590B@SHSMSX101.ccr.corp.intel.com>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1210121427490.2779@ionos>
 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
 <alpine.LFD.2.02.1210121440160.2779@ionos>
In-Reply-To: <alpine.LFD.2.02.1210121440160.2779@ionos>
Accept-Language: zh-CN, en-US
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

FLAG IRQS_ONESHOT does not work well for edge interrupt.
* IRQS_ONESHOT			- irq is not unmasked in primary handler

Is it possible give some notification or remind? Thanks. I took some time
to know it:)
