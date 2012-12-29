Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2L2Ehh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 23:37:37 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:9692 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab2L2Ehf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 23:37:35 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: PS-5(zzbb2dI98dI9371I936eI1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
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
Thread-Index: AQHN5RiGq5ZUqF9Ep0mmn4k4iukZYZgue5kAgAAXSYCAAALxAIAAF0EAgAACcwCAAC2GAIAAAfiAgAARq4CAAEGJgA==
Date: Sat, 29 Dec 2012 04:37:29 +0000
Message-ID: <E99CBA9F97C3D149AA6B19ED2E277C9B01921744@BY2PRD0510MB365.namprd05.prod.outlook.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	  <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
	  <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
	  <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
	  <50DE03D8.9030902@zytor.com>
	  <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
	  <35da3df5-ecac-4b57-83a2-828326e5bfc3@email.android.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B0192169D@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE3C8F.4000405@zytor.com>
In-Reply-To: <50DE3C8F.4000405@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4A7BF5DB02A514FA4C90B4E5679BD85@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBT4bea4028055

On Fri, 2012-12-28 at 16:42 -0800, H. Peter Anvin wrote:
> On 12/28/2012 03:39 PM, Matthew Garrett wrote:
> > On Fri, 2012-12-28 at 15:32 -0800, H. Peter Anvin wrote:
> >> No, that is explicitly the ordering that is excludable.
> > 
> > Windows uses the UEFI time functions. The fact that they fail for us on
> > a bunch of systems is just another symptom of our general failure to
> > accurately mimic Windows when making runtime calls, and we should just
> > make sure that that gets fixed rather than layering more workarounds on
> > top. It's an embarrassment that we're still unable to deal with
> > platforms that work fine with another OS. 
> > 
> 
> Are they using them in preference to ACPI?  This seems a bit odd, since
> one can presume that the ACPI functions were added at Microsoft's request...

In preference to the ACPI RTC, I haven't yet had an ACPI 5.0 TAD device
to test in comparison.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
