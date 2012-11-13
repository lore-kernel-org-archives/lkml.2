Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2KMIAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:00:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:49030 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab2KMIAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:00:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="246184684"
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
Thread-Index: AQHNwXSzc7ymnBQVR0ipwXxr7IQD7ZfnZrvw
Date: Tue, 13 Nov 2012 08:00:21 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1C3EE6@SHSMSX101.ccr.corp.intel.com>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
 <20121112172651.GC15159@pengutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A1C3952@SHSMSX101.ccr.corp.intel.com>
 <20121113075813.GA23119@pengutronix.de>
In-Reply-To: <20121113075813.GA23119@pengutronix.de>
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
> Sent: Tuesday, November 13, 2012 3:58 PM
> To: Liu, Chuansheng
> Cc: linus.walleij@linaro.org; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; linux-i2c@vger.kernel.org
> Subject: Re: [PATCH 1/7] I2c-nomadik: Fix the usage of
> wait_for_completion_timeout
> 
> 
> > Thanks your pointing out. I just manually reviewed the code when found
> > this point. Would like to try some auto-script but failed:)
> 
> I can suggest 'coccinelle' for that kind of job.
Thanks, let me try, if possible anyone can give some help?
> 
> --
> Pengutronix e.K.                           | Wolfram Sang
> |
> Industrial Linux Solutions                 | http://www.pengutronix.de/
> |
