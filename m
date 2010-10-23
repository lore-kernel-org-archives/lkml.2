Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0JWCSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:18:43 -0400
Received: from mail.wdtv.com ([66.118.69.84]:33873 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0JWCSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:18:42 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: 2.6.36, make oldconfig broken
Date: Fri, 22 Oct 2010 22:18:38 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; i686; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
References: <201010221229.36996.gene.heskett@gmail.com> <4CC20011.5010809@oracle.com> <20101023010717.GA20750@deepthought>
In-Reply-To: <20101023010717.GA20750@deepthought>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010222218.38266.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 22, 2010, Ken Moffat wrote:
>On Fri, Oct 22, 2010 at 02:20:17PM -0700, Randy Dunlap wrote:
>> On 10/22/10 13:08, Gene Heskett wrote:
>> > But I'll be interested in what you get.  Its stuff like this that
>> > have made me wary of downloading the kernel images in .bz2 formats,
>> > too many times I have had to go back and get the .gz version because
>> > the unpacking of the .bz2 upchucked and silently threw away a subdir
>> > tree, and only a fresh download fixes it, blowing it away and
>> > unpacking the bz2 again will only fix it occasionally.  I started
>> > with the tar.gz of course this time.
>> 
>> Curiouser and curiouser.
>> I always download & build from .bz2 tarballs, with no problems.
>
> On my own x86 machines, I can remember seeing apparently corrupted
>.tar.bz2 files twice in the last eight-or-so years.  In each case,
>untarring reported an error, it didn't silently lose files and
>directories, and in each case the problem was failing memory.
>
> In Gene's case, I recommend running memtest86 or better ('+') as
>soon as possible.  On my problematic x86 boxes, memtest86 started to
>report errors within a minute or so of starting.  If it runs for a
>whole cycle, the memory is probably ok.
>
>ken

I haven't done that in 6 months or so, but will the next time I reboot.  
The last time I had any errors from memtest+ was about 18 months back, and 
a thorough re-seating of the memory seemed to fix it.  Maybe its due again?

Thanks for the reminder Ken.  One tends to 'get in a rut' in the later 
years, forgetting such.

I will report what happens when I do.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
To the landlord belongs the doorknobs.
