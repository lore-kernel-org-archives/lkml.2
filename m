Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0I3NV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:21:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:26609 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab0I3NV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:21:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,259,1283756400"; 
   d="scan'208";a="662674122"
From: "Shi, Alex" <alex.shi@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Norbert Preining <preining@logic.at>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Fu, Michael" <michael.fu@intel.com>
Date: Thu, 30 Sep 2010 21:21:22 +0800
Subject: RE: high power consumption in recent kernels
Thread-Topic: high power consumption in recent kernels
Thread-Index: ActgnB3c73zFZr/PR0uDTrBfx+MZogABe1KA
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B2E73741C41@shsmsx502.ccr.corp.intel.com>
References: <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com>
	 <20100909205115.GD11053@gamma.logic.tuwien.ac.at>
	 <1284107099.402.30.camel@laptop>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
	 <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
	 <1284355277.26157.8109.camel@debian>
	 <20100922154452.GA9080@gamma.logic.tuwien.ac.at>
	 <1285670426.21962.43.camel@debian> <4CA34F95.30400@logic.at>
	 <1285807841.21962.1147.camel@debian>
	 <20100930065902.GC15882@gamma.logic.tuwien.ac.at>
	 <1285835230.21962.1290.camel@debian> <1285850185.2144.49.camel@laptop>
In-Reply-To: <1285850185.2144.49.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Thanks Norbert!
>> Mike&Peter:
>> would you like to add signed-off for the following patch?
>
>I would really rather see the nohz decision move into the whole cpuidle
>governor thing, which can make a much better cost vs benefit decision.
>
See! 
