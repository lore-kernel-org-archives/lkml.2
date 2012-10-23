Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab2JWU0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:26:16 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58099 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2JWU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <20121024072347.65f3e930@notabene.brown>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-62-git-send-email-keescook@chromium.org>
	<20121024072347.65f3e930@notabene.brown>
Date: Tue, 23 Oct 2012 13:26:11 -0700
X-Google-Sender-Auth: yHKsXxTU56OKKCkj3hKSOlSNpH8
Message-ID: <CAGXu5j+QqZVjKWZyeSp1nYjP66UCZ9tzARJpeLLeJf9n-BoEhw@mail.gmail.com>
Subject: Re: [PATCH 061/193] drivers/md: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 1:23 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 23 Oct 2012 13:02:14 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, remove it.
>>
>> CC: Neil Brown <neilb@suse.de>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/md/Kconfig |   25 ++++++++++++-------------
>>  1 file changed, 12 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 91a02ee..f583e96 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -155,10 +155,9 @@ config MD_RAID456
>>         If unsure, say Y.
>>
>>  config MULTICORE_RAID456
>> -     bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
>> +     bool "RAID-4/RAID-5/RAID-6 Multicore processing"
>>       depends on MD_RAID456
>>       depends on SMP
>> -     depends on EXPERIMENTAL
>>       ---help---
>>         Enable the raid456 module to dispatch per-stripe raid operations to a
>>         thread pool.
>
> I'm happy to remove the "depends on EXPERIMENTAL".
> I'm not so happy to remove the "(EXPERIMENTAL)" text.  That code really
> shouldn't be used in production - just for experiments.

No problem; I've updated the patch to leave the title alone.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
