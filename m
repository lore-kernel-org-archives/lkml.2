Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2AYC0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 21:26:47 -0500
Received: from mail2.nsc.com ([12.238.8.132]:56168 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755817Ab2AYC0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 21:26:46 -0500
X-WSS-ID: 0LYC1GJ-0A-46C-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Tue, 24 Jan 2012 18:26:34 -0800
Subject: RE: [PATCH 2/7] leds-lm3530: add 'name' in lm3530_platform_data
Thread-Topic: [PATCH 2/7] leds-lm3530: add 'name' in
 lm3530_platform_data
Thread-Index: AczaAonkPZz5TK/ZS7evWF8UGByRKgBAufdQ
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3E61@EXMAIL03.scwf.nsc.com>
References: <AczXFXB5tuUxDiyyTP+0MvKxJb7yTg==>
 <B567DBAB974C0544994013492B949F8E3812C6D0CA@EXMAIL03.scwf.nsc.com>
 <CACRpkdb577CTML0MvXAyYdHqM1LfqMv-x27SQwhwsLvBOLpAtg@mail.gmail.com>
In-Reply-To: <CACRpkdb577CTML0MvXAyYdHqM1LfqMv-x27SQwhwsLvBOLpAtg@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6301B7D71LS9909176-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: Linus Walleij [mailto:linus.walleij@linaro.org] 
Sent: Tuesday, January 24, 2012 4:09 AM
To: Kim, Milo
Cc: shreshthakumar.sahu@stericsson.com; linux-kernel@vger.kernel.org; rpurdie@rpsys.net
Subject: Re: [PATCH 2/7] leds-lm3530: add 'name' in lm3530_platform_data

On Fri, Jan 20, 2012 at 2:47 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

>> The led device name can be configurable.

> OK, why?

For example, there are two platforms with the lm3530.
In project A, the name of led is used as 'lcd-backlight'.
And in project B, the led name is set to 'lcd-bl'.
If an user-space accesses different name each project/platform, then lm3530 led name should be changed.

If the name can be configurable in the platform data, then no driver change needed.

Thanks & BR
Milo -

