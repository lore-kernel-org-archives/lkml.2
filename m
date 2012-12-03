Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab2LCT7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:59:07 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:6322 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2LCT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:59:04 -0500
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Borislav Petkov <bp@alien8.de>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/3] aerdrv: Trace Event for AER
Thread-Topic: [PATCH v4 1/3] aerdrv: Trace Event for AER
Thread-Index: AQHN0YcqW9X0YAlVw0GID3XVvKQIGpgHfabw
Date: Mon, 3 Dec 2012 19:58:16 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516EE70A@G4W3218.americas.hpqcorp.net>
References: <20121203183305.26636.22979.stgit@grignak.americas.hpqcorp.net>
 <20121203185059.GA14798@liondog.tnic>
In-Reply-To: <20121203185059.GA14798@liondog.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB3JxARd004995

> > +/*
> > + * PCIe Advanced Error Reporting (AER) PCIE Report Error
> 
> Why do you insist on keeping this convoluted compound name? What does
> "PCIe AER PCIe Report Error" even mean?
> 
> This is not unreadable technical documentation but something people
> should actually understand. And it is simply a PCIe AER tracepoint. So
> why the h*ll not call it by its real name?

I will fix that.

> 
> > + *
> > + * These events are generated when hardware detects a corrected or
> > + * uncorrected event on a pci express device. The event report has
> 
> And you should stick to the same spelling for PCIe throughout the text,
> so choose one and use it everywhere.
> 
Ok

> 
> Also, you haven't addressed Mauro's comment about other bits in the
> spec
> which are not here. Why are you skipping them?

I missed that mail. I will address that.

Lance
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
