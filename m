Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2L1THp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:07:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37703 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab2L1THm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:07:42 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 28 Dec 2012 11:07:11 -0800
To: Matthew Garrett <matthew.garrett@nebula.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>
Message-ID: <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do have such machines, which is why this change has been reverted twice already.  I believe we should stick to the priority scheme I proposed a few weeks ago.

Matthew Garrett <matthew.garrett@nebula.com> wrote:

>On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
>> UEFI time services, GetTime(), SetTime(), GetWakeupTime(),
>SetWakeupTime() are also
>> supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
>> 
>> This patch changed RTC_DRV_EFI configuration to depend on EFI but not
>just IA64. It
>> checks efi_enabled flag and efi-rtc driver should enabled.
>
>In theory, certainly - but do we still have machines that explode if
>the
>get_time call is made? We may also want to think about disabling the
>legacy access to the RTC if the EFI calls are present.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
