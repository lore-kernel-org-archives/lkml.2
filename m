Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1E3RDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:03:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54630 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab1E3RDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:03:06 -0400
Message-ID: <4DE3CDBF.8000108@zytor.com>
Date: Mon, 30 May 2011 10:02:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add Dell E5420 reboot quirk
References: <1305248699-2347-1-git-send-email-daniel.blueman@gmail.com>	<69e8f8a9-4e8b-4c02-b566-304ff837d166@email.android.com>	<BANLkTi=h5f6o3iVK24sQ20xYYQAMbLavMg@mail.gmail.com>	<BANLkTik9BtnXxsOGKuhmoUFsKPbhBwXr3A@mail.gmail.com>	<4DE3C652.5090309@zytor.com> <BANLkTinnEPKC+Nb7zK_PswU+M=sNPxWCig@mail.gmail.com>
In-Reply-To: <BANLkTinnEPKC+Nb7zK_PswU+M=sNPxWCig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2011 09:52 AM, Daniel J Blueman wrote:
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

Oh, okay.  Dropping the patch, then.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

