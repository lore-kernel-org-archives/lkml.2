Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369Ab2EJShA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:37:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65130 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761329Ab2EJSg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120510111958.7cb00da9.akpm@linux-foundation.org>
References: <1336609592-3825-1-git-send-email-bryan.wu@canonical.com> <20120510111958.7cb00da9.akpm@linux-foundation.org>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 11 May 2012 02:36:36 +0800
X-Google-Sender-Auth: cpfty0h8bSI4CRM0E_EfME1Th6c
Message-ID: <CAK5ve-LYW6gkZ1Ew76THu5jJDjfyH57EL6eTGC8s9n6d77a3wQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add maintainer for LED subsystem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 2:19 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 10 May 2012 08:26:32 +0800
> Bryan Wu <bryan.wu@canonical.com> wrote:
>
>> Add Bryan Wu as the primary maintainer for drivers/leds
>>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>> ---
>>  MAINTAINERS |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7071633..de4e280 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -4034,6 +4034,7 @@ F:      Documentation/scsi/53c700.txt
>>  F:   drivers/scsi/53c700*
>>
>>  LED SUBSYSTEM
>> +M:   Bryan Wu <bryan.wu@canonical.com>
>>  M:   Richard Purdie <rpurdie@rpsys.net>
>>  S:   Maintained
>>  F:   drivers/leds/
>
> Please set up a git tree based on Linus mainline, get that tree
> included in linux-next (by emailing Stephen) and include its git
> URL in this MAINTAINERS record.
>

Actually I have account on kernel.org, but it was removed maybe after
we restored kernel.org due to attacking. So is possible for me to
apply it again, I was told I need more GPG  key signed, right? Or I
will setup a tree in kernel.ubuntu.com/git.

> Once that is all set up I'll send over the current leds queue -
> currently 17 patches.
>

Nice, 17 patches is a good start for me.

> We don't presently have a leds mailing list.  I generally find stuff by
> reading linux-kernel.  You'll now need to do that ;) Even if we did
> have a leds mailing list, one would still need to follow lkml to avoid
> losing stuff.
>
> Or you can not bother - I read lkml and shall grab stray leds patches and
> will send them on to yourself.
>

let's setup a leds mailing list, is it possible have on vger? I will
also monitor lkml with your help.

Thanks a lot,
-Bryan
