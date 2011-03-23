Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1CWHaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:30:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53060 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab1CWHaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:30:21 -0400
Message-ID: <4D89A225.1060701@cn.fujitsu.com>
Date: Wed, 23 Mar 2011 15:32:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: jiaweiwei.xiyou@gmail.com
CC: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH]Clean up CodingStyle for scripts/kconfig/gconf.c
References: <20110322143839.GA10291@gmail.com> <4D894CD0.9030509@cn.fujitsu.com> <20110323070017.GA3731@gmail.com>
In-Reply-To: <20110323070017.GA3731@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-23 15:28:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-23 15:28:53,
	Serialize complete at 2011-03-23 15:28:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> Hi us,
>>>    	Clean up CodingStyle for scripts/kconfig/gconf.c.
>>> 
>> 
>> What makes you think this is a bad style? Does Documentation/CodingStyle say
>> so? Does checkpatch.pl make a complain? Do you really think this improves
>> readability? I don't think so, and actually it makes the code worse.
> But we all write '#include <***>'. I have never seen '#  include <***>'.

Then let's see:

$ find -name '*.c' -exec grep -H '^# .*include' {} \;
./drivers/char/mem.c:# include <linux/efi.h>
./drivers/char/random.c:# include <linux/irq.h>
./drivers/scsi/nsp32.c:# include "nsp32_debug.c"
./drivers/video/epson1355fb.c:#  include <mach/hardware.h>

You can look into those cases, and then you should be able to figure out
why.

>> 
>> Run checkpatch.pl on this file, and you'll see lots of errors and warnings,
>> but pure codingstyle cleanup is rarely worth anything, so better don't do
>> that.
> I am sorry, I have not got your meaning clearly.

Codingstyle cleanups aren't worth your time, and it would be better for you
and for the kernel project as a whole if you can find something more valuable
to work on.

>> 
>>> Thanks.
>>> Best Regards.
>>> Harry Wei.
>>> 
>>> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
>>> ---
>>>  scripts/kconfig/gconf.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>> 
>>> diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
>>> index 4558961..56da945 100644
>>> --- a/scripts/kconfig/gconf.c
>>> +++ b/scripts/kconfig/gconf.c
>>> @@ -7,7 +7,7 @@
>>>   */
>>>  
>>>  #ifdef HAVE_CONFIG_H
>>> -#  include <config.h>
>>> +#include <config.h>
>>>  #endif
>>>  
>>>  #include "lkc.h"
