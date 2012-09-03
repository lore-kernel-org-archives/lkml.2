Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2ICWPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 18:15:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60555 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2ICWPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 18:15:13 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, "Hilman, Kevin" <khilman@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>
Subject: RE: [PATCH] gpio:clk: preparation for switch to common clock
 framework
Thread-Topic: [PATCH] gpio:clk: preparation for switch to common clock
 framework
Thread-Index: AQHNhtnW6A4se/jITEybW2JJ4We5tZd04sSAgARSagA=
Date: Mon, 3 Sep 2012 22:15:10 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041B059A@DFLE12.ent.ti.com>
References: <1346349837-10521-1-git-send-email-m-karicheri2@ti.com>
 <CACRpkdZ_jN6SmuzGnKeopHbohHn9bK8tRgrMKBVLatfJDBKsqw@mail.gmail.com>
In-Reply-To: <CACRpkdZ_jN6SmuzGnKeopHbohHn9bK8tRgrMKBVLatfJDBKsqw@mail.gmail.com>
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
>> From: Linus Walleij [mailto:linus.walleij@linaro.org]
>> Sent: Friday, August 31, 2012 7:14 PM
>> To: Karicheri, Muralidharan; Hilman, Kevin; Nori, Sekhar
>> Cc: grant.likely@secretlab.ca; linux-kernel@vger.kernel.org; mturquette@linaro.org
>> Subject: Re: [PATCH] gpio:clk: preparation for switch to common clock framework
>> 
>> On Thu, Aug 30, 2012 at 8:03 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
>> 
>> > As a first step towards migrating davinci platforms to use common clock
>> > framework, replace all instances of clk_enable() with clk_prepare_enable()
>> > and clk_disable() with clk_disable_unprepare(). Until the platform is
>> > switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
>> > adds a might_sleep() call and would work without any issues.
>> >
>> > This will make it easy later to switch to common clk based implementation
>> > of clk driver from DaVinci specific driver.
>> >
>> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> 
>> OK the patch is so obviously correct so I just applied it, DaVinci folks,
>> scream if you still don't want it for some reason...
>> 
Linus,

Thanks for applying this patch.

Murali Karicheri
Software Design Engineer
>> Yours,
>> Linus Walleij
