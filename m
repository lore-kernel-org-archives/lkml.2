Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1GAQFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:05:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62935 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1GAQFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:05:35 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinnEPKC+Nb7zK_PswU+M=sNPxWCig@mail.gmail.com>
References: <1305248699-2347-1-git-send-email-daniel.blueman@gmail.com>
	<69e8f8a9-4e8b-4c02-b566-304ff837d166@email.android.com>
	<BANLkTi=h5f6o3iVK24sQ20xYYQAMbLavMg@mail.gmail.com>
	<BANLkTik9BtnXxsOGKuhmoUFsKPbhBwXr3A@mail.gmail.com>
	<4DE3C652.5090309@zytor.com>
	<BANLkTinnEPKC+Nb7zK_PswU+M=sNPxWCig@mail.gmail.com>
Date: Sat, 2 Jul 2011 00:05:33 +0800
Message-ID: <BANLkTiktLdMiSa7bOCkrRxmngx-=CONSew@mail.gmail.com>
Subject: Re: [PATCH] x86: Add Dell E5420 reboot quirk
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2011 00:52, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> On 31 May 2011 00:31, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 05/30/2011 07:43 AM, Daniel J Blueman wrote:
>>>
>>> Without this patch, rebooting is like Russian roulette; with quite a
>>> few of these laptops in the field, perhaps it is better to enable the
>>> quirk unless you think there may be an issue in the kernel preventing
>>> correct behaviour that I could debug?
>>>
>>> On the other hand, Dell may later fix the BIOS AML (seen with the
>>> excellent fwts) just as the cure for cancer is found. If they do, I'll
>>> buy whiskey too.
>
>> Enabling the quirk is the right thing; however, if ACPI worked I'd have
>> preferred it since we just switched to ACPI as the default.
>
> Indeed - the new and default ACPI reboot method works perfectly in
> 3.0-rc1, whereas with 2.6.39, it didn't, so no further need for this
> patch then.

I slipped up, since after finally now moving on from 2.6.39, I removed
the 'reboot=p' boot parameter; it turns out that 3.0-rc1 through -rc5
do need this workaround; and the BIOS isn't changed. Honest. So, I
didn't double-check that I had booted without it.

Can you queue up the patch please (earlier in the thread)? Probably we
should consider it for stable too, due to the hassle it brings. Let me
know if we should debug would be useful for this problem.

Thanks,
  Daniel
-- 
Daniel J Blueman
