Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1LEJhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:37:53 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:53273 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754476Ab1LEJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:37:52 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>
Date: Mon, 5 Dec 2011 10:37:38 +0100
Subject: RE: [RFCv2 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory
 Drivers
Thread-Topic: [RFCv2 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory
 Drivers
Thread-Index: Acyw6ilJNJwWgeRZQ5WdwIK2wB919QCRmBGQ
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0C6614C@EXDCVYMBSTM005.EQ1STM.local>
References: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1322595550-6473-9-git-send-email-sjur.brandeland@stericsson.com>
 <1322827296.2313.21.camel@x61.thuisdomein>
In-Reply-To: <1322827296.2313.21.camel@x61.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB59c1n5005250

Hi Paul,

> Spotted some typos, see below.
>> +	Say "Y" if you want to character device for External Shared
> Perhaps "[...] to use a character device for the [...]"?

>> +	Only say "M" here if you want to test XSHM and needs to load
> s/needs/need/.

So, I will change drivers/xshm/Kconfig like this:
-       Say "Y" if you want to character device for External Shared
+       Say "Y" to use a character device for the External Shared
...
-       Only say "M" here if you want to test XSHM and needs to load
+       Only say "M" here if you want to test XSHM and need to load

Thank you Paul for a thorough review here.

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
