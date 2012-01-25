Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2AYCDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 21:03:04 -0500
Received: from mail2.nsc.com ([12.238.8.132]:37750 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755618Ab2AYCDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 21:03:02 -0500
X-WSS-ID: 0LYC0CZ-0A-3YS-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Tue, 24 Jan 2012 18:02:43 -0800
Subject: RE: [PATCH 4/7] leds-lm3530: add 'lm3530_mode_get()' in the
 lm3530 device attribute
Thread-Topic: [PATCH 4/7] leds-lm3530: add 'lm3530_mode_get()' in the
 lm3530 device attribute
Thread-Index: AczaA3waoiKPWQYGQlmB+6//KZm5pgBAUOWQ
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3E4B@EXMAIL03.scwf.nsc.com>
References: <AczXFb0awj5rU2NWTZyzBVK6p9EmMg==>
 <B567DBAB974C0544994013492B949F8E3812C6D0D0@EXMAIL03.scwf.nsc.com>
 <CACRpkdb5rnNSVZBTVATi5i64ynz3zS+VfEx2Bi2tusTAMc2zDg@mail.gmail.com>
In-Reply-To: <CACRpkdb5rnNSVZBTVATi5i64ynz3zS+VfEx2Bi2tusTAMc2zDg@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6301BD4D1LS9908828-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, but this patch is additional function for 'mode' device attribute.
'Mode' attribute already exists before this patch.
Then, should I add some explanation under Documentation ?

Thanks & BR
Milo -


-----Original Message-----
From: Linus Walleij [mailto:linus.walleij@linaro.org] 
Sent: Tuesday, January 24, 2012 4:16 AM
To: Kim, Milo
Cc: shreshthakumar.sahu@stericsson.com; linux-kernel@vger.kernel.org; rpurdie@rpsys.net
Subject: Re: [PATCH 4/7] leds-lm3530: add 'lm3530_mode_get()' in the lm3530 device attribute

On Fri, Jan 20, 2012 at 2:49 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> To get information about brightness control mode, lm3530_mode_get() is added.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

When adding new ABIs, create a Documentation/ABI/testing/* file
for the new attribute explaining what it is and how it works.

Yours,
Linus Walleij

