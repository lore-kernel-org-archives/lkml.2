Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab2IMSpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:45:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48961 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab2IMSpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:45:02 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "Nori, Sekhar" <nsekhar@ti.com>, "Hilman, Kevin" <khilman@ti.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: i2c:clk: preparation for switch to common clock framework
Thread-Topic: i2c:clk: preparation for switch to common clock framework
Thread-Index: AQHNkZJShtIH+19bX0mLHdaClUCHwJeInCnQ
Date: Thu, 13 Sep 2012 18:44:33 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041BCDC1@DFLE12.ent.ti.com>
References: <1346350236-11105-1-git-send-email-m-karicheri2@ti.com>
 <20120913092943.GA5912@pengutronix.de>
In-Reply-To: <20120913092943.GA5912@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Wolfram Sang [mailto:w.sang@pengutronix.de]
>> Sent: Thursday, September 13, 2012 5:30 AM
>> To: Karicheri, Muralidharan
>> Cc: Nori, Sekhar; Hilman, Kevin; khali@linux-fr.org; ben-linux@fluff.org; davinci-linux-
>> open-source@linux.davincidsp.com; linux-i2c@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: i2c:clk: preparation for switch to common clock framework
>> 
>> On Thu, Aug 30, 2012 at 06:10:36PM -0000, m-karicheri2@ti.com wrote:
>> > As a first step towards migrating davinci platforms to use common
>> > clock framework, replace all instances of clk_enable() with
>> > clk_prepare_enable() and clk_disable() with clk_disable_unprepare().
>> > Until the platform is switched to use the CONFIG_HAVE_CLK_PREPARE
>> > Kconfig variable, this just adds a might_sleep() call and would work without any issues.
>> >
>> > This will make it easy later to switch to common clk based
>> > implementation of clk driver from DaVinci specific driver.
>> >
>> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> 
>> Subject had "i2c:clk" where "i2c: davinci" would be more precise.
>> 
>> Fixed that and pushed to -next.
>> 
>> Thanks,
>> 
>>    Wolfram

Wolfram,

Thanks for pushing this to -next. Greatly appreciated.

Murali
>> 
>> --
>> Pengutronix e.K.                           | Wolfram Sang                |
>> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
