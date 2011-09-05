Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1IEWuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 18:50:17 -0400
Received: from lucidpixels.com ([72.73.18.11]:55880 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab1IEWuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 18:50:14 -0400
Date: Mon, 5 Sep 2011 18:50:13 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Re: kernel: 3.1-rc4: disk tracing query [SOLVED]
In-Reply-To: <alpine.DEB.2.02.1109051758360.23828@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1109051849400.5804@p34.internal.lan>
References: <alpine.DEB.2.02.1109051758360.23828@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Sep 2011, Justin Piszcz wrote:

> Hello,
>
> I found that samba seems to stat() the filesystems that are shared out even 
> if you are not accessing the ones in question, e.g.:
>
> /raid
> /home/user
>
> If I access the server by \\name it will check all of the directories and 
> thus wake the raid.
> For now I've disabled samba to stop this behavior.
>
> However, I am still noticing my raid waking up from time to time, I've tried 
> using gresecurity to track down what is getting exec()'d before it wakes but 
> I have not had any luck finding out what it is-- no useful notes in the raid 
> ctrl logs either.
>
> Is there a way I can get the kernel to log what program/syscall/etc is trying 
> to access a particular block device so I can find out what is causing the 
> raid to wake up?
>
> Justin.
>

Hello,

Someone has replied to me off-list, it is:

echo 1 >/proc/sys/vm/block_dump

Thanks,

Justin.


