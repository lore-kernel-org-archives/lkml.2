Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2L1Rn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 12:43:57 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:13286
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782Ab2L1Rn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:43:56 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zz98dI936eI1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Thread-Topic: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Thread-Index: AQHN5RiGq5ZUqF9Ep0mmn4k4iukZYZgue5kA
Date: Fri, 28 Dec 2012 17:43:50 +0000
Message-ID: <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
In-Reply-To: <1356712001-12198-1-git-send-email-jlee@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D76E7D75B8BBDC42BBEF0926AA18BF94@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBSHi6lc024944

On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
> UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeupTime() are also
> supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
> 
> This patch changed RTC_DRV_EFI configuration to depend on EFI but not just IA64. It
> checks efi_enabled flag and efi-rtc driver should enabled.

In theory, certainly - but do we still have machines that explode if the
get_time call is made? We may also want to think about disabling the
legacy access to the RTC if the EFI calls are present.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
