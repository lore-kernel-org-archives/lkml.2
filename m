Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2ATRa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:30:57 -0500
Received: from mail2.nsc.com ([12.238.8.132]:59860 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754906Ab2ATRax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:30:53 -0500
X-WSS-ID: 0LY3XZ9-0A-56Z-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Fri, 20 Jan 2012 09:30:36 -0800
Subject: RE: [PATCH 7/7] leds-lm3530: enhanced arithmetic operation
Thread-Topic: [PATCH 7/7] leds-lm3530: enhanced arithmetic operation
Thread-Index: AczXaAnQO4X6/zNQTj+smsi/7bP5bwAKwmTA
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD364F@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812C6D0D7@EXMAIL03.scwf.nsc.com>
 <4F19267C.7010307@metafoo.de>
 <B567DBAB974C0544994013492B949F8E3812CD356C@EXMAIL03.scwf.nsc.com>
 <4F195273.9020108@metafoo.de>
In-Reply-To: <4F195273.9020108@metafoo.de>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 63077B481LS9825782-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The reason why dividing by two is only 7-bits of brightness value in the LM3530 register.
>> 
>> Bit7 | bit6 | bit5 | bit4 | bit3 | bit2 | bit1 | bit0
>> ------------------------------------------------------
>>  N/A |        LED Brightness Data (Bits[6:0])
>> ------------------------------------------------------
>> 
>> So maximum value is limited to 127.

> So the max_brightness property of your led should be set to 127.

That's good point. Thanks a lot !
Additional patch needs for this.

Best Regards,
Milo -

