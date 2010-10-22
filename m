Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab0JVVUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:20:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41008 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab0JVVUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:20:40 -0400
Message-ID: <4CC20011.5010809@oracle.com>
Date: Fri, 22 Oct 2010 14:20:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36, make oldconfig broken
References: <201010221229.36996.gene.heskett@gmail.com> <20101022114019.60839ff2.randy.dunlap@oracle.com> <201010221608.36754.gene.heskett@gmail.com>
In-Reply-To: <201010221608.36754.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/10 13:08, Gene Heskett wrote:
> On Friday, October 22, 2010, Randy Dunlap wrote:
>> On Fri, 22 Oct 2010 12:29:36 -0400 Gene Heskett wrote:
>>
>> [adding linux-kbuild]
>>
>>> Greets all;
>>>
>>> I have managed to get 2.6.36 to a semi-usable state, but I have major
>>> breakage yet.
>>>
>>> Question: what happens if I simply move my working 2.6.35.7 .config
>>> into the 2.6.36 tree and build it from that?
>>
>> I think that it runs 'make oldconfig' automatically for you.
>>
>>> It can't be any worse than what the broken 'make oldconfig' did to it. 
>>> What it output changed the disk drivers, graphic card drivers and just
>>> plain threw away at least a hundred lines in the multimedia drivers
>>> section.

When I use your config-2.6.36.7 file on 2.6.36 and run 'make oldconfig',
I don't see anything like changes in disk or graphics card drivers and
I don't see 100 or more lines thrown away in the multimedia drivers.

Did you use 'make oldconfig' or did you use that script that you have
mentioned and posted in the past?  Could it be causing problems?


>>> How do you suggest I recover from this if just building from the
>>> 2.6.35.7 .conf doesn't work?
>>
>> Please send your 2.6.35.7 .config file so that we can generate & see the
>> changes.
> 
> Attached Randy, & many thanks.
> 
> Just for S&G I overwrote the generated .config in the 2.6.36 tree with these 
> files, and ran a make xconfig, which bitched about line 3109, and which I 
> don't recall ever playing with, "RAR_REGISTER" IIRC, so I saved it without 
> any other changes and built/installed & booted from that now.
> 
> My only problem now seems to be with cheese for my elderly webcam and my 
> experience with using the nvidia drivers on my milling machine would seem 
> to indicate that the nvidia blob is locking out the IRQ's for too long, 
> which interferes with the steady stream my webcam puts out, so I get a 
> partial screen and a shell window full of:
> ibv4lconvert: Error decompressing JPEG: fill_nbits error: need 5 more bits
> libv4lconvert: Error decompressing JPEG: fill_nbits error: need 2 more bits
> 
> Which of course is not your fault as I'm 'tainted'.  And it works well with 
> the vesa driver, which also points an accusing finger at the nvidia driver 
> blob.  What else is new. ;-)
> 
> But I'll be interested in what you get.  Its stuff like this that have made 
> me wary of downloading the kernel images in .bz2 formats, too many times I 
> have had to go back and get the .gz version because the unpacking of the 
> .bz2 upchucked and silently threw away a subdir tree, and only a fresh 
> download fixes it, blowing it away and unpacking the bz2 again will only fix 
> it occasionally.  I started with the tar.gz of course this time.

Curiouser and curiouser.
I always download & build from .bz2 tarballs, with no problems.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
