Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2LEQRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:17:34 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17730 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2LEQRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:17:31 -0500
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
Subject: RE: [PATCH v7 3/3] aerdrv: Cleanup log output for CPER based AER
Thread-Topic: [PATCH v7 3/3] aerdrv: Cleanup log output for CPER based AER
Thread-Index: AQHN0vfhDALzaN6ENUmfWv7GIyb9XJgKYVjA
Date: Wed, 5 Dec 2012 16:16:31 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516F37AA@G4W3219.americas.hpqcorp.net>
References: <20121204210305.4515.91100.stgit@grignak.americas.hpqcorp.net>
 <20121204210318.4515.10180.stgit@grignak.americas.hpqcorp.net>
 <20121205145035.GE2364@liondog.tnic>
In-Reply-To: <20121205145035.GE2364@liondog.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.26]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB5GHeja014979

> 
> Here it is, you're initializing 'prefix' here although it is being
> used in the previous patch. You should concentrate the whole prefix
> initialization and passing in one patch so that there are no breakages.

Yes I probably could have broken up the patches in a cleaner way.  Thanks.

> 
> Also, why is it exactly 44 chars long, is that some magic number
> that always works? At least this is what aer_print_error does
> too. I'm guessing someone chose it because it is large enough for
> dev_driver_string() and dev_name() and a couple more formatting
> characters. Oh well.
> 

Yes, I was using the same code as in aer_print_error.  This was brought up in a previous mail with Joe and we discussed cleaning all of this up in a later patch.

Lance

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
