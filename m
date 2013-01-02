Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3ABSRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:17:53 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62502 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3ABSRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:17:52 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyr2ZUzab3sV13VzcRmSp+St36Eo_tdUhnHDt3jz5p9HQ@mail.gmail.com>
References: <50E3F49E.4090005@monstr.eu>
	<CA+55aFyr2ZUzab3sV13VzcRmSp+St36Eo_tdUhnHDt3jz5p9HQ@mail.gmail.com>
Date: Wed, 2 Jan 2013 19:17:51 +0100
Message-ID: <CAHTX3dK0MFv9U+o6K+3byKi2sh66o0FfwjRurduBU=_1r+e3wA@mail.gmail.com>
Subject: Re: [GIT PULL] arch/microblaze changes for 3.8-rc2
From: Michal Simek <monstr@monstr.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/2 Linus Torvalds <torvalds@linux-foundation.org>:
> On Wed, Jan 2, 2013 at 12:49 AM, Michal Simek <monstr@monstr.eu> wrote:
>> Hi Linus,
>>
>> please pull these 3 patches.
>> They fix noMMU kernel and I have also added defconfig updates
>> which fix issue with one external dependency and enable
>> all xilinx device drivers for 0-day testing system.
>
> No. I'm not pulling 3000 lines of broken defconfig crap.
>
> That defconfig update is pure and utter shit, and changes from the
> minimal kind of defconfig to the old-style "everything and the kitchen
> sink" crap.
>
> We started doing that defconfig minimization for a reason. See commit
> 8b1bb90701f9 for example. We're not going back to the bad old days,
> and I'm not pulling thousands of lines or pure garbage noise just
> because you were too lazy to do it right.

ok. I wasn't aware of it. I will fix it.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian
