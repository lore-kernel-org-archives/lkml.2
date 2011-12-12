Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1LLHyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:54:50 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:49238 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459Ab1LLHyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:54:49 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Michal Marek <mmarek@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 12 Dec 2011 08:54:06 +0100
Subject: RE: [PATCHv2 06/10] xshm: Add xshm device implementation
Thread-Topic: [PATCHv2 06/10] xshm: Add xshm device implementation
Thread-Index: Acy3RNHv4tVeWxamRuylLAGqgnDkiwBXjx7A
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0D6B971@EXDCVYMBSTM005.EQ1STM.local>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
 <1323439648-22697-7-git-send-email-sjur.brandeland@stericsson.com>
 <4EE36737.9070701@suse.cz>
In-Reply-To: <4EE36737.9070701@suse.cz>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBC7sviX017120

Hi Michal

>> +MODULE_VERSION("XSHM 0.6 : " __DATE__);
>
>Please drop the __DATE__ macro, it results in builds that are not
>reproducible.

OK, thanks - I'll drop this in next release.

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
