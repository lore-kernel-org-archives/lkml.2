Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2CVSbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:31:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40665 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2CVSbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:31:21 -0400
Message-ID: <4F6B6FDB.80507@zytor.com>
Date: Thu, 22 Mar 2012 11:30:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas@biessmann.de>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Michal Marek <mmarek@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86, build: remove unused include
References: <1329324589-26907-1-git-send-email-andreas@biessmann.de> <20120322101719.GC1406@localhost>
In-Reply-To: <20120322101719.GC1406@localhost>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 03:17 AM, Andreas Bießmann wrote:
> On Wed, Feb 15, 2012 at 05:49:49PM +0100, Andreas Bießmann wrote:
>> Commit 079f85e624189292d1c818b47764916bf8cf84a8 removed necessity for
>> sys/sysmacros.h include but missed to remove the include.
>>
>> Still requiring sys/sysmacros.h for build tool breaks cross compiling x86 kernel
>> on non linux style systems which may not offer sys/sysmacros.h.
>>
>> Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
>> ---
>>  arch/x86/boot/tools/build.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
>> index 4e9bd6b..52628cd 100644
>> --- a/arch/x86/boot/tools/build.c
>> +++ b/arch/x86/boot/tools/build.c
>> @@ -29,7 +29,6 @@
>>  #include <stdarg.h>
>>  #include <sys/types.h>
>>  #include <sys/stat.h>
>> -#include <sys/sysmacros.h>
>>  #include <unistd.h>
>>  #include <fcntl.h>
>>  #include <sys/mman.h>
>> -- 
> 
> are there any objections against that patch? could anyone take it if not?

An equivalent patch has been in tip:x86/build for a while and was just
pulled upstream by Linus.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

