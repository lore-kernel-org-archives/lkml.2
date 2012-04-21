Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2DUWf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 18:35:29 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34907 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751645Ab2DUWf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 18:35:28 -0400
Message-ID: <4F93364E.2010805@xenotime.net>
Date: Sat, 21 Apr 2012 15:35:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Valentin Ilie <valentin.ilie@gmail.com>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: sys.c: Fixed coding style issues
References: <1335008543-13399-1-git-send-email-valentin.ilie@gmail.com>	<CAFLxGvx+-P3SvLUPhZF5MW68Ss-9m59BfOY1SeqtjVtWaQk+qA@mail.gmail.com> <CAHuBVBZtCJ_o2DR9+z+BokS05JbCn2-zAh5sBnpwZo97-YaReA@mail.gmail.com>
In-Reply-To: <CAHuBVBZtCJ_o2DR9+z+BokS05JbCn2-zAh5sBnpwZo97-YaReA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 08:27 AM, Valentin Ilie wrote:

>> This kind of patch is not easy to review.
>> Can you please prove that no logic has changed?
>> E.g. By comparing the object file before and after your patch...
> 
> Everything seems to be OK.
> 
> The diff is because the old version had an unnecessary \n in two places.

But Richard asked you to compare the object files (binary files,
kernel/sys.o) to make sure that they are the same.


> $ checkpatch.pl -q --file --terse /tmp/test/sys.c | grep total
> total: 33 errors, 18 warnings, 2057 lines checked
> $ checkpatch.pl -q --file --terse /tmp/test/sys_patched.c | grep total
> total: 4 errors, 14 warnings, 2055 lines checked
> 
> $ diff -iEbwB sys.c sys_patched.c
> 215,216c215
> < 			else if ((who != cred->uid) &&
> < 				 !(user = find_user(who)))
> ---
>> 		else if ((who != cred->uid) && !(user = find_user(who)))
> 280,281c279
> < 			else if ((who != cred->uid) &&
> < 				 !(user = find_user(who)))
> ---
>> 		else if ((who != cred->uid) && !(user = find_user(who)))
> 
> 



-- 
~Randy
