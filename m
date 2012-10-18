Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2JRIfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:35:23 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:47776 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2JRIfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:35:20 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mischa Jonker <mischa.jonker@synopsys.com>
CC: "m.d.s.x.jonker@gmail.com" <m.d.s.x.jonker@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: [PATCH] Input: serio - Add ARC PS/2 driver
Thread-Topic: [PATCH] Input: serio - Add ARC PS/2 driver
Thread-Index: AQHNrE+oUof2xrDiDU6PIszNm3PElpe+f3QAgAA9upA=
Date: Thu, 18 Oct 2012 08:35:17 +0000
Message-ID: <E6BF041E97966E4DB955F0DF883AD2D6019A2E@DE02WEMBX1.internal.synopsys.com>
References: <1350468619-4813-1-git-send-email-mischa.jonker@synopsys.com>
 <1350468619-4813-2-git-send-email-mischa.jonker@synopsys.com>
 <20121018065004.GA12838@core.coreip.homeip.net>
In-Reply-To: <20121018065004.GA12838@core.coreip.homeip.net>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.24.43]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thanks again for your quick reply. 

>> +	void *data, *status;
>These 2 should be annotated as __iomem. May I also suggest calling them data_addt and status_addr?
I assume you meant data_addr.

>> +		dev_err(&pdev->dev, "memory allocation failed cannot get the I/O addr 0x%x\n",
>> +			(unsigned int)arc_ps2->iomem_res->start);
> I think we have a format specifier for resources.
Thanks, didn't know that!

>> +	iounmap((void __iomem *) arc_ps2->addr);
> No need to cast to __iomem here.
These are remains from the time that addr was still an 'unsigned' (while using inl/outl). Updated.

Patch v3 will follow in due course.


Thanks again,

Mischa
