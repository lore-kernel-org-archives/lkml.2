Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0H3IrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:47:13 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:44645 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab0H3IrL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:47:11 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 30 Aug 2010 10:46:27 +0200
Subject: RE: [PATCH] MFD: Align AB8500 with the abx500.h interface
Thread-Topic: [PATCH] MFD: Align AB8500 with the abx500.h interface
Thread-Index: ActBEiG8cd2yBGTwTauRVmXvVwHGrQHDY36w
Message-ID: <CEE6BB42CAD6E947908279175AF8470A026B21F26B@EXDCVYMBSTM006.EQ1STM.local>
References: <1282382428-10389-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1282382428-10389-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: EG/P P8TR QAri S2Ms ZMMo ahev g468 j36S kjOb k/X5 lv4W
 npIL pZ+t vubD vxpM
 34h0;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYgByAG8AbwBuAGkAZQBAAG8AcABlAG4AcwBvAHUAcgBjAGUALgB3AG8AbABmAHMAbwBuAG0AaQBjAHIAbwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAcgBnAEAAcwBsAGkAbQBsAG8AZwBpAGMALgBjAG8ALgB1AGsAOwBzAGEAbQBlAG8AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA=;Sosha1_v1;7;{5532BCA9-F136-42D8-862C-CE272B6825CF};bABpAG4AdQBzAC4AdwBhAGwAbABlAGkAagBAAHMAdABlAHIAaQBjAHMAcwBvAG4ALgBjAG8AbQA=;Mon,
 30 Aug 2010 08:46:27
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAATQBGAEQAOgAgAEEAbABpAGcAbgAgAEEAQgA4ADUAMAAwACAAdwBpAHQAaAAgAHQAaABlACAAYQBiAHgANQAwADAALgBoACAAaQBuAHQAZQByAGYAYQBjAGUA
x-cr-puzzleid: {5532BCA9-F136-42D8-862C-CE272B6825CF}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Self]

> From: Mattias Wallin <mattias.wallin@stericsson.com>
> 
> This patch consolidates the ab8500 mixed signal chip to expose the
> same interface for register access as the ab3100, ab3550 and ab5500
> chips. The ab8500_read() and ab8500_write() are removed and replaced
> with abx500_get_register_interruptible() and
> abx500_set_register_interruptible() respectively.

Sam,
is this one OK or do I need to spin it around/split it more?

Yours,
Linus Walleij
