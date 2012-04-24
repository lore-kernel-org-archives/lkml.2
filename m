Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2DXVKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:10:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2DXVKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:10:11 -0400
Message-ID: <4F97173C.5010808@gmail.com>
Date: Wed, 25 Apr 2012 07:12:28 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Julia Lawall <julia.lawall@lip6.fr>, Jingoo Han <jg1.han@samsung.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/ep93xx-fb.c: clean up error-handling code
References: <1334777828-3557-1-git-send-email-Julia.Lawall@lip6.fr>	 <4F8F5938.2000207@gmail.com>	 <000401cd1dd2$5f8ee3b0$1eacab10$%han@samsung.com>	 <alpine.DEB.2.02.1204190713200.1954@localhost6.localdomain6> <1335271586.25429.19.camel@joe2Laptop>
In-Reply-To: <1335271586.25429.19.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/12 22:46, Joe Perches wrote:

> On Thu, 2012-04-19 at 07:14 +0200, Julia Lawall wrote:
>> I don't know thw impact of the ./.  I use the options
>>
>> --nokeywords --nogit-fallback --subsystem --norolestats -f
>>
>> julia
>>
>> On Thu, 19 Apr 2012, Jingoo Han wrote:
>>
>>>> -----Original Message-----
>>>> From: Ryan Mallon
> []
>>>> Oddly, scripts/get_maintainer.pl on this file doesn't return me, even
>>>> though, according to git blame, I am the author of 90% of the commits.
>>>> Should I have an entry in the MAINTAINERS file, or is
>>>> scripts/get_maintainer.pl not working properly?
>>>
>>> There are optional differences in using scripts/get_maintainer.pl.
>>> If you use './' ahead of file path, you will see your name.
>>>
>>> Without './' ahead of 'drivers/video/ep93xx-fb.c':
>>> ./scripts/get_maintainer.pl --file drivers/video/ep93xx-fb.c
>>> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> (maintainer:FRAMEBUFFER LAYER)
>>> linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
>>> linux-kernel@vger.kernel.org (open list)
>>>
>>> With './' ahead of 'drivers/video/ep93xx-fb.c':
>>> ./scripts/get_maintainer.pl --file ./drivers/video/ep93xx-fb.c
>>> Ryan Mallon <rmallon@gmail.com> (commit_signer:2/3=67%)
>>> Paul Gortmaker <paul.gortmaker@windriver.com> (commit_signer:1/3=33%)
>>> H Hartley Sweeten <hsweeten@visionengravers.com> (commit_signer:1/3=33%)
>>> Jesper Juhl <jj@chaosbits.net> (commit_signer:1/3=33%)
>>> Jiri Kosina <jkosina@suse.cz> (commit_signer:1/3=33%)
>>> linux-kernel@vger.kernel.org (open list)
> 
> Prefixing "./" to the file path bypasses the normal
> get_maintainers pattern check for file maintainership.
> 
> Florian Schandinat and linux-fbdev are not returned
> in the second lookup above.
> 
> One of the patterns for FRAMEBUFFER is
> F:	drivers/video/
> which is a direct match for is ep93xx-fb.c file,
> so --git is not used by default.
> 
> Adding --git may be appropriate and it also returns
> Ryan's name in this case.


Hi Joe,

Thanks for the info.

> Nominally, as framebuffer maintainer, Florian
> should also have "signed-off" on these commits,
> but many subsystems don't actually have a
> single path or person for patches and commits.

> 
> This file came into the tree via Andrew Morton.
> 

The original driver was written before Florian became the 
framebuffer maintainer. The subsystem had no real maintainer
at the time, which is why it went via Andrew.

> About maintainership for individual files:
> 
> If anyone thinks they are the maintainer for
> a particular file, generally they should submit
> a patch to MAINTAINERS adding a section with
> their name, maintainership level and an
> appropriate file pattern.


Hmm, perhaps author is a better term than maintainer here. Any 
patches should still go via the framebuffer maintainer, Florian,
but it would be useful in many cases for the original and/or
most regular commit author to also get Cc'ed since in many
cases they will have a better understanding of the code, even
if the aren't "maintaining" it.

~Ryan

