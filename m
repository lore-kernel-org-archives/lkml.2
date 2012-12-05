Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2LEQO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:14:58 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:15706 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab2LEQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:14:56 -0500
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
Subject: RE: [PATCH v7 2/3] aerdrv: Enhanced AER logging
Thread-Topic: [PATCH v7 2/3] aerdrv: Enhanced AER logging
Thread-Index: AQHN0vVauyr9T3d0TkCW6Jisswkti5gKXzlw
Date: Wed, 5 Dec 2012 16:14:14 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516F279F@G4W3219.americas.hpqcorp.net>
References: <20121204210305.4515.91100.stgit@grignak.americas.hpqcorp.net>
 <20121204210312.4515.13415.stgit@grignak.americas.hpqcorp.net>
 <20121205143202.GD2364@liondog.tnic>
In-Reply-To: <20121205143202.GD2364@liondog.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB5GF7br014939

> > +	char *prefix = NULL;
> 
> What are you doing here? You dropped the 'prefix' argument being passed
> down in this function and are defining a local variable of the same
> name
> which is used in the function later:
> 
>         printk("%s""aer_status: 0x%08x, aer_mask: 0x%08x\n",
>                prefix, status, mask);
> 

Boris,

I removed the prefix argument because it was never used by its caller and never set.  The reason I added the prefix variable and set it to NULL was to help in breaking up the patch and adding it would help the intermittent patch build without changing too much code.   I knew I was actually going to use the variable in patch 3. 

Lance

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
