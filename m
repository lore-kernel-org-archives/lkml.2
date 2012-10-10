Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2JJOTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:19:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54220 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab2JJOTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:19:44 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "Hilman, Kevin" <khilman@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 02/13] clk: davinci - add PSC clock driver
Thread-Topic: [PATCH 02/13] clk: davinci - add PSC clock driver
Thread-Index: AQHNpuU13ZG8RkfixU2CzP6weaSYtpeylnIg
Date: Wed, 10 Oct 2012 14:19:30 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041FB6AA@DFLE12.ent.ti.com>
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com>
 <1348682889-9509-3-git-send-email-m-karicheri2@ti.com>
 <50756B96.1070008@ti.com> <50756DFD.4070203@ti.com>
In-Reply-To: <50756DFD.4070203@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9AIUPV3002606

>> -----Original Message-----
>> From: Nori, Sekhar
>> Sent: Wednesday, October 10, 2012 8:46 AM
>> To: Nori, Sekhar
>> Cc: Karicheri, Muralidharan; Hilman, Kevin; davinci-linux-open-
>> source@linux.davincidsp.com; mturquette@linaro.org; linux-c6x-dev@linux-c6x.org;
>> arnd@arndb.de; linus.walleij@linaro.org; linux-kernel@vger.kernel.org;
>> rob.herring@calxeda.com; linux-keystone@list.ti.com - Linux developers for Keystone
>> family of devices (May contain non-TIers); viresh.linux@gmail.com;
>> linux@arm.linux.org.uk; akpm@linux-foundation.org; shawn.guo@linaro.org; linux-arm-
>> kernel@lists.infradead.org
>> Subject: Re: [PATCH 02/13] clk: davinci - add PSC clock driver
>> 
>> On 10/10/2012 6:05 PM, Sekhar Nori wrote:
>> 
>> >> +struct clk *clk_register_davinci_psc(struct device *dev, const char *name,
>> >> +			const char *parent_name,
>> >> +			struct clk_davinci_psc_data *psc_data,
>> >> +			spinlock_t *lock)
>> >
>> > Why do you need the lock to be provided from outside of this file? You
>> > can initialize a lock for serializing writes to PSC registers within
>> > this file, no?
>> 
>> Looking again, it seems like the common clock framework defines an "enable_lock" in
>> drivers/clk/clk.c to serialize the clock enable/disable calls. Unless I am missing something,
>> this lock seems unnecessary.
>> 

I think you are right. For enable() api, enable_lock is sufficient and I will remove this.

>> Thanks,
>> Sekhar
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
