Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1LEJne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:43:34 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:33600 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869Ab1LEJnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:43:32 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 5 Dec 2011 10:43:21 +0100
Subject: RE: [RFCv2 9/9] caif-xshm: Add CAIF driver for Shared memory for
 M7400
Thread-Topic: [RFCv2 9/9] caif-xshm: Add CAIF driver for Shared memory for
 M7400
Thread-Index: Acyw6I5woKEpvo0cR2OdsBpEDhiCnQCRuxFQ
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0C66166@EXDCVYMBSTM005.EQ1STM.local>
References: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1322595550-6473-10-git-send-email-sjur.brandeland@stericsson.com>
 <1322826606.2313.14.camel@x61.thuisdomein>
In-Reply-To: <1322826606.2313.14.camel@x61.thuisdomein>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB59hi5P005305

Hi Paul,
 
> A few minor comments follow. They're basically identical to some of my
> comments on v1 of 8/9 ("xshm: Makefile and Kconfig for M7400 Shared
> Memory Drivers"). I guess I just didn't spot these the first time.

No worries, I should have fix this all over based on your previous comments anyway.


> > +config CAIF_XSHM
> > +	tristate "CAIF external memory protocol driver"
> > +	depends on XSHM && CAIF
> > +	default n
> > +	---help---
> > +	Say "yes" if you want to support CAIF over External Shared Memory
> (XSHM)
> 
> "Say Y"?
> 
> > +	IPC mechanism (e.g. over Chip to Chip).
> > +	This will normally be built-in, loadable module is used for
> testing.
> 
> Perhaps something like: "Only say M here if you want to test CAIF over
> XSHM and need to load and unload its module."?

So I will change drivers/net/caif/Kconfig like this:
-       Say "yes" if you want to support CAIF over External Shared Memory (XSHM)
-       IPC mechanism (e.g. over Chip to Chip).
-       This will normally be built-in, loadable module is used for testing.
+       Say "Y" if you want to support CAIF over External Shared Memory (XSHM)
+       IPC mechanism (e.g. over Chip to Chip). Only say M here if you want to
+       test CAIF over XSHM and need to load and unload its module.
        If unsure say N.

Thank you for reviewing this Paul.

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
