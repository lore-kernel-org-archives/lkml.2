Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab1G2LA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:00:57 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:60690 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab1G2LAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:00:55 -0400
Message-ID: <4E3292B5.6090507@gentoo.org>
Date: Fri, 29 Jul 2011 14:00:05 +0300
From: Stratos Psomadakis <psomas@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 1/2] staging: fix zcache building
References: <1311556452-1859-1-git-send-email-cascardo@holoscopio.com> <a5d17beb-847b-48c0-82d7-cfabe419e7f9@default>
In-Reply-To: <a5d17beb-847b-48c0-82d7-cfabe419e7f9@default>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (ulysses.noc.ntua.gr [147.102.222.230]); Fri, 29 Jul 2011 14:00:40 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 06:19 AM, Dan Magenheimer wrote:
>> From: Thadeu Lima de Souza Cascardo [mailto:cascardo@holoscopio.com]
>> Sent: Sunday, July 24, 2011 7:14 PM
>> To: Nitin Gupta
>> Cc: Dan Magenheimer; Greg Kroah-Hartman; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org;
>> Thadeu Lima de Souza Cascardo
>> Subject: [PATCH 1/2] staging: fix zcache building
>>
>> zcache is only building tmem.c and not building zcache.c. To keep the
>> module name, zcache.c must be renamed if symbols from tmem.c are to
>> remain unexported.
>>
>> Signed-off-by: Thadeu Lima de Souza Cascardo<cascardo@holoscopio.com>
>
> Greg --
>
> Since a newer version of zcache.c is already in staging-next (and
> hopefully soon in staging-for-linus for the 3.1 window), this
> patch, which simply replaces the (older) zcache.c with identical
> code with a different filename, would not apply cleanly.  Could
> you advise on the best way to ensure both the newer version
> and the file rename are applied... perhaps the rename must be
> done manually in your git tree(s)?
>
> Though I'm not certain of the process steps, please consider the
> rename, the one liner Makefile change for the rename, and the GPL
> module license addition (in patch 2/2)...
>
> Acked-by: Dan Magenheimer<dan.magenheimer@oracle.com>
>
> Thanks,
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Will this fix get included in the 3.0.1 -stable release? (zcache is 
'broken' (doesn't build) in Linux-3.0)

Btw, I noticed that there was another patch sent [1] to fix this issue 
earlier, but the original author is not mentioned in the first patch of 
this thread, which fixes the build failure (and the patches are almost 
identical I think).

[1] https://lkml.org/lkml/2011/6/22/54

Thanks,
Stratos

-- 
Stratos Psomadakis
<psomas@gentoo.org>

