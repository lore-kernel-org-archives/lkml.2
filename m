Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2L1Tsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:48:30 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:47636
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab2L1TRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:54 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Thread-Topic: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Thread-Index: AQHN5RiGq5ZUqF9Ep0mmn4k4iukZYZgue5kAgAAXSYCAAALxAA==
Date: Fri, 28 Dec 2012 19:17:43 +0000
Message-ID: <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
In-Reply-To: <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA7ACE77748F6D48B373E12EF12E6ED0@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBSJmWXf026268

On Fri, 2012-12-28 at 11:07 -0800, H. Peter Anvin wrote:
> We do have such machines, which is why this change has been reverted twice already.  I believe we should stick to the priority scheme I proposed a few weeks ago.

I seem to have missed that discussion, and couldn't find it after a
brief search. Got a pointer?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
