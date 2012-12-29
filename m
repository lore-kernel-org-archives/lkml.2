Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab2L2FTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 00:19:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41294 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab2L2FTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 00:19:46 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B01921744@BY2PRD0510MB365.namprd05.prod.outlook.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com> <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com> <50DE03D8.9030902@zytor.com> <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com> <35da3df5-ecac-4b57-83a2-828326e5bfc3@email.android.com> <E99CBA9F97C3D149AA6B19ED2E277C9B0192169D@BY2PRD0510MB365.namprd05.prod.outlook.com> <50DE3C8F.4000405@zytor.com> <E99CBA9F97C3D149AA6B19ED2E277C9B01921744@BY2PRD0510MB365.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 28 Dec 2012 21:19:21 -0800
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Message-ID: <ed3971f1-8464-4406-bae2-eff914c9c2fc@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, we could hack a simulator and try it.

Matthew Garrett <matthew.garrett@nebula.com> wrote:

>On Fri, 2012-12-28 at 16:42 -0800, H. Peter Anvin wrote:
>> On 12/28/2012 03:39 PM, Matthew Garrett wrote:
>> > On Fri, 2012-12-28 at 15:32 -0800, H. Peter Anvin wrote:
>> >> No, that is explicitly the ordering that is excludable.
>> > 
>> > Windows uses the UEFI time functions. The fact that they fail for
>us on
>> > a bunch of systems is just another symptom of our general failure
>to
>> > accurately mimic Windows when making runtime calls, and we should
>just
>> > make sure that that gets fixed rather than layering more
>workarounds on
>> > top. It's an embarrassment that we're still unable to deal with
>> > platforms that work fine with another OS. 
>> > 
>> 
>> Are they using them in preference to ACPI?  This seems a bit odd,
>since
>> one can presume that the ACPI functions were added at Microsoft's
>request...
>
>In preference to the ACPI RTC, I haven't yet had an ACPI 5.0 TAD device
>to test in comparison.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
