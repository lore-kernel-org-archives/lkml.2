Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2L2GSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 01:18:38 -0500
Received: from [65.55.88.13] ([65.55.88.13]:13577 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751405Ab2L2GSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 01:18:36 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIda00hzz1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Thread-Topic: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Thread-Index: AQHN5RiGq5ZUqF9Ep0mmn4k4iukZYZgue5kAgAAXSYCAAALxAIAAF0EAgAACcwCAAC2GAIAAAfiAgAARq4CAAEGJgIAAC7OAgAAQVwA=
Date: Sat, 29 Dec 2012 06:17:50 +0000
Message-ID: <E99CBA9F97C3D149AA6B19ED2E277C9B01921795@BY2PRD0510MB365.namprd05.prod.outlook.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE03D8.9030902@zytor.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <35da3df5-ecac-4b57-83a2-828326e5bfc3@email.android.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B0192169D@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE3C8F.4000405@zytor.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B01921744@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <ed3971f1-8464-4406-bae2-eff914c9c2fc@email.android.com>
In-Reply-To: <ed3971f1-8464-4406-bae2-eff914c9c2fc@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <35FEFD29729E69479BBBCE18C2AF038E@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBT6Ikin028170

On Fri, 2012-12-28 at 21:19 -0800, H. Peter Anvin wrote:
> Again, we could hack a simulator and try it.

Yeah, shouldn't be too hard to wedge into qemu/ovmf.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
