Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab0HJMBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:01:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:51977 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0HJMBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:01:35 -0400
Message-ID: <4C613F95.8020505@windriver.com>
Date: Tue, 10 Aug 2010 07:01:25 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Jon Masters <jonathan@jonmasters.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why can't i use gdb to dump module variables anymore?
References: <alpine.DEB.2.00.1007080744180.7016@lynx> <7C33277E-D90E-4459-8580-59C5EFB2D66D@jonmasters.org> <alpine.DEB.2.00.1008091200520.3863@lynx>
In-Reply-To: <alpine.DEB.2.00.1008091200520.3863@lynx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2010 12:01:23.0074 (UTC) FILETIME=[C071B620:01CB3883]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 11:06 AM, Robert P. J. Day wrote:
> On Sun, 8 Aug 2010, Jon Masters wrote:
>
>   
>> On Jul 8, 2010, at 7:51 AM, Robert P. J. Day wrote:
>>     
>>> (gdb) p rpjday_2
>>> Cannot access memory at address 0xffffffffa007c0b4
>>> (gdb) p rpjday_3
>>> Cannot access memory at address 0xffffffffa007c0b8
>>>       
>> Did you ever get a reply to this one? Were you trying to do this
>> locally, by loading a kernel core or using kgdb?
>>     
>
>   never figured out what was happening here, used to work just fine
> for simple gdb debugging of the kernel; nowadays (at least on ubuntu),
> not so much.  anyway, i'm in bahstahn for linuxcon, staying at the
> onyx hotel for first 3 days.  my girlfriend is doing a bofs session:
>
> http://events.linuxfoundation.org/linuxcon2010/mckinnon
>
>   anyway, regarding gdb, this was based on a column i wrote last
> year:
>
> http://www.linux.com/learn/linux-training/33991-the-kernel-newbie-corner-kernel-and-module-debugging-with-gdb
>
> where it worked just fine -- it's the technique described in LDD3.
> but now, on ubuntu 10.04, weirdness.  i haven't looked at it closely
> again for a while, but if you have any ideas, i'm open to suggestions.
> maybe some odd security/selinux/??? setting?
>   

I took a brief look at the instructions you had a the URL.  It seemed
like something that should probably work ok unless that memory address
is really not accessible via /proc/kcore.

Depending on the age of the ubuntu system and if you have a serial port
or not, kgdb is actually enabled in the kernel and you could certainly
try the same test there.

It should also be possible to try out a gdb with kernel module awareness
on the /proc/kcore.  If you want to try and debug it at some point
perhaps we'll cross paths at LinuxCON.

Jason
