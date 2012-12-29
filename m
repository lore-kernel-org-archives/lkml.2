Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2L2BDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 20:03:03 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:48858 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2L2BDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 20:03:01 -0500
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 Dec 2012 09:00:03 +0800
Message-ID: <1356742803.6113.245.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2012-12-28 於 17:43 +0000，Matthew Garrett 提到：
> On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
> > UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeupTime() are also
> > supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
> > 
> > This patch changed RTC_DRV_EFI configuration to depend on EFI but not just IA64. It
> > checks efi_enabled flag and efi-rtc driver should enabled.
> 
> In theory, certainly - but do we still have machines that explode if the
> get_time call is made? We may also want to think about disabling the
> legacy access to the RTC if the EFI calls are present.

The legacy get_time access on my test machine is work fine, not thing
explode. :-)
Just we have a function want to expose the timezone information to
userspace and also store it.


Thanks a lot!
Joey Lee


