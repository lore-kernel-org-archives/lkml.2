Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863Ab1EIEDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 00:03:14 -0400
Received: from mail.wdtv.com ([66.118.69.84]:49843 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1EIEDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 00:03:10 -0400
From: gene heskett <gheskett@wdtv.com>
To: Connor H <cmdkhh@gmail.com>
Subject: Re: trying to build 2.6.38.5?
Date: Mon, 9 May 2011 00:03:05 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.5-pclos1.pae.bfs; KDE/4.6.3; i686; ; )
References: <201105082023.09878.gene.heskett@gmail.com> <201105082112.14959.gheskett@wdtv.com> <BANLkTik5uTMRpg5mj2MtnW+MZDgWwOgyUQ@mail.gmail.com>
In-Reply-To: <BANLkTik5uTMRpg5mj2MtnW+MZDgWwOgyUQ@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105090003.05756.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 08, 2011, Connor H wrote:
>unable to reproduce using the included config file,
>
>Connor

Thanks for looking, Conner.  I suspect I am missing some -devel file, but 
didn't really want to shotgun in everything in the pclos repos.

The reason for the push to do it is of course the nvidia blob, it will not 
install if the kernel headers don't match the running kernel.  I'll keep 
poking at it though.
 
>On Sun, May 8, 2011 at 6:12 PM, gene heskett <gheskett@wdtv.com> wrote:
>> On Sunday, May 08, 2011, Randy Dunlap wrote:
>>>On Sun, 8 May 2011 20:23:09 -0400 Gene Heskett wrote:
>>>> At the end of a make -j2 all:
>>>> 
>>>> /home/gene/src/linux-2.6.38.5-gene/include/linux/Kbuild:25: ***
>>>> commands commence before first target. �Stop.
>>>> make[2]: *** [linux] Error 2
>>>> make[2]: *** Waiting for unfinished jobs....
>>>> make[1]: *** [headers_install] Error 2
>>>> make: *** [vmlinux] Error 2
>>>> 
>>>> What am I missing?
>>>
>>>I can't reproduce this problem. �Please post your kernel .config file.
>>>
>> Attached, thanks Randy.
>> 
>> --
>> Cheers, Gene
>> "There are four boxes to be used in defense of liberty:
>> �soap, ballot, jury, and ammo. Please use in that order."
>> -Ed Howdershelt (Author)
>> <http://tinyurl.com/ddg5bz>
>> <http://www.cantrip.org/gatto.html>
>> Paranoia is heightened awareness.
>> 
>> --
>> Cheers, Gene
>> "There are four boxes to be used in defense of liberty:
>> �soap, ballot, jury, and ammo. Please use in that order."
>> -Ed Howdershelt (Author)
>> <http://tinyurl.com/ddg5bz>
>> <http://www.cantrip.org/gatto.html>
>> All I ask of life is a constant and exaggerated sense of my own
>> importance.


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<http://tinyurl.com/ddg5bz>
<http://www.cantrip.org/gatto.html>
<JHM> Somehow I have more respect for 14 year old Debian developers than
     14 year old Certified Microsoft Serfs.
