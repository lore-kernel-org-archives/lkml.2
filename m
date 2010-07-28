Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0G1Ad4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 20:33:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:47043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab0G1Adv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 20:33:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,271,1278313200"; 
   d="scan'208";a="590335748"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>,
        Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Date: Tue, 27 Jul 2010 18:33:49 -0600
Subject: RE: e1000e crashes with 2.6.34.x and ThinkPad T60
Thread-Topic: e1000e crashes with 2.6.34.x and ThinkPad T60
Thread-Index: AcsrF9sVYPDpcye4Rm6zqDr136KvKgC09ghA
Message-ID: <EA929A9653AAE14F841771FB1DE5A1366000F42E28@rrsmsx501.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
In-Reply-To: <20100724092644.GA13353@torres.zugschlus.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o6S0YF41023876

Marc Haber wrote:
> Hi,
> 
> I have a new notebook, a Thinkpad T60, which is freezing in random
> intervals (like 30 minutes to two days) as long as I am using the
> on-board wired ethernet interface, which is an e1000e, [8086:109a]. As
> long as I keep using the WLAN, the system runs for weeks despite
> frequent suspend/resume cycles etc. The crashes seem really to be tied
> to using the wired ethernet. This is a hard freeze, with nothing
> happening on the system, only a long push on the power button helps.

When the crashes occur - is there a trace on the screen?

Do you know of a way to reproduce the issue? For example were
you downloading files, browsing internet, or using the ethernet device
in any way when the system crashed?

> Additionally, sometimes, probably after suspend/resume, the wired
> ethernet does not come up properly again, ip addr claims "NO CARRIER"
> even if the LEDs on the interface and on the switch claim that there
> was a link. No packets are received by the interface when it's at this
> stage.
> 
> Both issues appear with 2.6.34 and 2.6.34.1. I didn't try any of these
> issues with an older kernel, 2.6.34 was already out when I started
> using the T60.

I got a T60 notebook running on 2.6.34.1 and will try to reproduce in house.

> 
> To rule out defective hardware, I have tried with a second T60, with
> the same results.
> 
> Full dmesg and lspci-nn attached, please say if you need more.

Doesn't seem that there were any attachments to this email. 
Could you also provide the kernel config?

> Greetings
> Marc

Thanks,
Emil
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
