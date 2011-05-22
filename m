Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1EVUJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:09:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59065 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1EVUIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ArBrSKROUQhS/H+XmTf2XOXERizwbBiyXuraHKndjahaXyc9KpTLKuXoDoxLoMfRHg
         MHpwktk2p0Fra0kdB4MjZgd2WLNWOx18P/gfgdnHVq572e/OlQBouY3It7r3P5J9ArF3
         r4lvzTV+pRKQZ8RUabZfKUaWRRfrvCwidKCUQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTin6=3rpchVFHi9P=6Cp31uL=vMM0w@mail.gmail.com>
References: <1306092879.16902.1.camel@monotop>
	<BANLkTin6=3rpchVFHi9P=6Cp31uL=vMM0w@mail.gmail.com>
Date: Sun, 22 May 2011 16:08:54 -0400
Message-ID: <BANLkTinRJ12Jc4u1OpB67cc3T3Trhci3dw@mail.gmail.com>
Subject: Re: [PATCH] fs: add missing prefetch header to inode.c
From: Eduardo Silva <edsiper@gmail.com>
To: sedat.dilek@gmail.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oh, yep, it was in UM arch :)

On Sun, May 22, 2011 at 4:04 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Sun, May 22, 2011 at 9:34 PM, Eduardo Silva <edsiper@gmail.com> wrote:
>> inode.c fails in the compilation process due to the missing
>> include of linux/prefetch.h.
>>
>> Signed-off-by: Eduardo Silva <edsiper@gmail.com>
>> ---
>>  fs/inode.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 33c963d..c77081f 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/posix_acl.h>
>>  #include <linux/ima.h>
>>  #include <linux/cred.h>
>> +#include <linux/prefetch.h>
>>  #include "internal.h"
>>
>>  /*
>> --
>> 1.7.4.1
>>
>
> Just FYI:
> "fs: add missing prefetch.h include" is in Linus tree [1].
>
> - Sedat -
>
> [1] http://git.us.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9ce6e0be0626a5de2aca8b769a4aa57086257156
>



-- 
Eduardo Silva
http://edsiper.linuxchile.cl
http://www.monkey-project.com
