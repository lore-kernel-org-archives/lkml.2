Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0I2PtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:49:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:6209 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab0I2PtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:49:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,253,1283756400"; 
   d="scan'208";a="842032110"
From: "Chen, Tim C" <tim.c.chen@intel.com>
To: Norbert Preining <preining@logic.at>, "Shi, Alex" <alex.shi@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
Date: Wed, 29 Sep 2010 09:48:54 -0600
Subject: RE: high power consumption in recent kernels
Thread-Topic: high power consumption in recent kernels
Thread-Index: Actf5Dd7WdE4iWjiQ1WuqORSXER0CQACPgIg
Message-ID: <EA929A9653AAE14F841771FB1DE5A136602222979F@rrsmsx501.amr.corp.intel.com>
References: <1284355277.26157.8109.camel@debian>
	 <1284689374.17745.89.camel@debian> <1283840425.26157.6486.camel@debian>
	 <20100909093140.GC29648@gamma.logic.tuwien.ac.at>
	 <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com>
	 <20100909205115.GD11053@gamma.logic.tuwien.ac.at>
	 <1284107099.402.30.camel@laptop>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
	 <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
	 <1284355277.26157.8109.camel@debian>
	 <20100922154452.GA9080@gamma.logic.tuwien.ac.at>
 <1285670426.21962.43.camel@debian> <4CA34F95.30400@logic.at>
In-Reply-To: <4CA34F95.30400@logic.at>
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

Norbert,

Can you try with the no-hz ratelimit now code REMOVED, and see if 
that will reduce your system power and cpu wakeups further.
Your last testing has the no-hz ratelimit code and we will like
to compare the effect with and without the code.

Sorry for the confusion.

Tim

>-----Original Message-----
>From: Norbert Preining [mailto:preining@logic.at] 
>Sent: Wednesday, September 29, 2010 7:39 AM
>To: Shi, Alex
>Cc: Peter Zijlstra; Chen, Tim C; arjan@infradead.org; 
>efault@gmx.de; Li, Shaohua; tglx; 
>linux-kernel@vger.kernel.org; Zhao, Yakui
>Subject: Re: high power consumption in recent kernels
>
>Hi Alex,
>
>> Could you like to try the following patch on your system and see how
>> many power it consumption now?
>
>But this patch is excately what you send me already and what I tried
>and I answered in the last email?
>
>Do I miss something here?
>
>All the best
>
>Norbert
>