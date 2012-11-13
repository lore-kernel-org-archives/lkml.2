Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2KMBWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:22:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:60677 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab2KMBWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:22:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="247991827"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH 1/7] I2c-nomadik: Fix the usage of
 wait_for_completion_timeout
Thread-Topic: [PATCH 1/7] I2c-nomadik: Fix the usage of
 wait_for_completion_timeout
Thread-Index: AQHNwPr2/eTCTB5cYE2EpQMCgMjOnZfm9uNQ
Date: Tue, 13 Nov 2012 01:21:57 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1C3952@SHSMSX101.ccr.corp.intel.com>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
 <20121112172651.GC15159@pengutronix.de>
In-Reply-To: <20121112172651.GC15159@pengutronix.de>
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



> -----Original Message-----
> From: Wolfram Sang [mailto:w.sang@pengutronix.de]
> Sent: Tuesday, November 13, 2012 1:27 AM
> To: Liu, Chuansheng
> Cc: linus.walleij@linaro.org; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; linux-i2c@vger.kernel.org
> Subject: Re: [PATCH 1/7] I2c-nomadik: Fix the usage of
> wait_for_completion_timeout
> 
> On Wed, Nov 07, 2012 at 01:18:37AM +0800, Chuansheng Liu wrote:
> >
> > The return value of wait_for_completion_timeout() is always
> > >= 0 with unsigned int type.
> >
> > So the condition "ret < 0" or "ret >= 0" is pointless.
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> 
> You forgot to add the i2c-list, so I nearly overlooked this patch.
> Luckily I haven't, so applied to for-next, thanks! Did you use a script
> to find all occurences? Would be nice to know. Also, please take care of
> the subject line. "I2c" is misspelled.
Thanks your pointing out. I just manually reviewed the code when found this point.
Would like to try some auto-script but failed:)
