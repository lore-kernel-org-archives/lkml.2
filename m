Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1HDHli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:41:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084Ab1HDHlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:41:32 -0400
MIME-Version: 1.0
In-Reply-To: <201108040715.p747FnXa042677@www262.sakura.ne.jp>
References: <201108040221.p742Lk3R069631@www262.sakura.ne.jp>
 <CACqU3MWQsh2cS8ck=c1-bOy-W649j0FjtNeOQbPaijAaCQ9wgA@mail.gmail.com>
 <201108040355.p743tBkv092694@www262.sakura.ne.jp> <CACqU3MVbHPuOjg9cY_GWdBGz3HPw3u7R3S14OOObN8-CFXGVaw@mail.gmail.com>
 <201108040715.p747FnXa042677@www262.sakura.ne.jp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Aug 2011 21:41:05 -1000
Message-ID: <CA+55aFwwGhRFjME-AmbB3DLb3Ux-vTBijMq1HS3VrSB47RV46w@mail.gmail.com>
Subject: Re: [3.0-git16] Oops at driver_uevent_store().
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: lacombar@gmail.com, bunk@stusta.de, greg@kroah.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/3 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
> Arnaud Lacombe wrote:
>> Marking `pci_eisa_driver' as __refdata fix the warning and leave the
>> struct untouched:
>>
>> diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
>> index 30da70d..cdae207 100644
>> --- a/drivers/eisa/pci_eisa.c
>> +++ b/drivers/eisa/pci_eisa.c
>
> This patch solved the oops. Thank you.

Arnaud, thanks. Sign-off and slightly cleaned-up changelog?

          Linus
