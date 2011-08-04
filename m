Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1HDOlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:41:24 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32898 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1HDOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:41:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwwGhRFjME-AmbB3DLb3Ux-vTBijMq1HS3VrSB47RV46w@mail.gmail.com>
References: <201108040221.p742Lk3R069631@www262.sakura.ne.jp>
	<CACqU3MWQsh2cS8ck=c1-bOy-W649j0FjtNeOQbPaijAaCQ9wgA@mail.gmail.com>
	<201108040355.p743tBkv092694@www262.sakura.ne.jp>
	<CACqU3MVbHPuOjg9cY_GWdBGz3HPw3u7R3S14OOObN8-CFXGVaw@mail.gmail.com>
	<201108040715.p747FnXa042677@www262.sakura.ne.jp>
	<CA+55aFwwGhRFjME-AmbB3DLb3Ux-vTBijMq1HS3VrSB47RV46w@mail.gmail.com>
Date: Thu, 4 Aug 2011 10:41:22 -0400
Message-ID: <CACqU3MUYdOAODPiiixSLrBRW=s8FM2ZNRMqNHL4L7QBc3SWmHw@mail.gmail.com>
Subject: Re: [3.0-git16] Oops at driver_uevent_store().
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, bunk@stusta.de,
        greg@kroah.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 4, 2011 at 3:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> 2011/8/3 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
>> Arnaud Lacombe wrote:
>>> Marking `pci_eisa_driver' as __refdata fix the warning and leave the
>>> struct untouched:
>>>
>>> diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
>>> index 30da70d..cdae207 100644
>>> --- a/drivers/eisa/pci_eisa.c
>>> +++ b/drivers/eisa/pci_eisa.c
>>
>> This patch solved the oops. Thank you.
>
> Arnaud, thanks. Sign-off and slightly cleaned-up changelog?
>
Sent in a separate patch; sorry for the breakage.

 - Arnaud
