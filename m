Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab2JHAvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:51:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:19912 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2JHAvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:51:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,549,1344236400"; 
   d="scan'208";a="153494404"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        "Tang, Feng" <feng.tang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: RE: [RESEND PATCH v4 0/2] ACPI: DBGP/DBG2 early console support for
 LPIA.
Thread-Topic: [RESEND PATCH v4 0/2] ACPI: DBGP/DBG2 early console support
 for LPIA.
Thread-Index: AQHNnUOrBkDYuFk+Zkq7bu7tl07myJesJCkAgAJ+ZUA=
Date: Mon, 8 Oct 2012 00:51:35 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88B9C2E4@SHSMSX101.ccr.corp.intel.com>
References: <cover.1347453194.git.zetalog@gmail.com>
 <cover.1348652044.git.lv.zheng@intel.com> <5065457E.4040500@zytor.com>
 <50707BB0.8050301@kernel.org>
In-Reply-To: <50707BB0.8050301@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q980plYY029047

> go ahead and take the series in tip 3.8, Peter, thanks.
> 
> I looked over this series a while back and my feedback was that it should be
> disabled by default and enabled by bootparam -- like other earlyprink -- else an
> issue here would render a system un-bootable.  I see that LV has addressed
> that in the latest version.
> LV,
> have you addressed the feedback from Konrad?

I missed the mail from Konrad. Thanks for your reminder.
I'll find it and update my patches according to his suggestion.

Best regards/Lv Zheng

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
