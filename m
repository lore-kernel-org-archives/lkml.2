Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0LFC26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:28:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:4665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab0LFC25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:28:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,304,1288594800"; 
   d="scan'208";a="357429799"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Kyungmin Park <kmpark@infradead.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Date: Mon, 6 Dec 2010 10:28:34 +0800
Subject: RE: [PATCH v2 1/4]enable background operations for supported eMMC
 card
Thread-Topic: [PATCH v2 1/4]enable background operations for supported eMMC
 card
Thread-Index: AcuU4qpm6Y0CF/0RSSG33D0U4x2RzgAB50XQ
Message-ID: <5D8008F58939784290FAB48F54975198320B3E464D@shsmsx502.ccr.corp.intel.com>
References: <20101203121338.GB18655@intel.com>
 <AANLkTikPAmpJq7Q7riDPGq5UkhAa9cuXRW7kjuNGv6oB@mail.gmail.com>
In-Reply-To: <AANLkTikPAmpJq7Q7riDPGq5UkhAa9cuXRW7kjuNGv6oB@mail.gmail.com>
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

> -----Original Message-----
> From: kyungmin78@gmail.com [mailto:kyungmin78@gmail.com] On Behalf Of
> Kyungmin Park
> Sent: Monday, December 06, 2010 9:12 AM
> To: Dong, Chuanxiao
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; cjb@laptop.org;
> akpm@linux-foundation.org; arjan@linux.intel.com; alan@linux.intel.com
> Subject: Re: [PATCH v2 1/4]enable background operations for supported eMMC
> card
> 
> <Tested-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Note that I'm not yet see any performance improvements :)

Thanks Park. Can you tell me the testing steps you used?
During the test, has there any background operation been started?
I think two cases can be tested to check whether there is performance improvement or not.
One is doing background operations when card is busy for reading/writing. The other is doing background operations when card is idle.

Thanks
Chuanxiao
