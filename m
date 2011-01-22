Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1AVWNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:13:45 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26233 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab1AVWNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:13:44 -0500
Date: Sat, 22 Jan 2011 23:14:15 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: John Linn <John.Linn@xilinx.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: console problem?, close(2) hangs /sbin/init
In-Reply-To: <7110b8bd-1411-4a92-81b7-1a76f5d5cb65@SG2EHSMHS005.ehs.local>
Message-ID: <alpine.LNX.2.00.1101222312560.7746@swampdragon.chaosbits.net>
References: <7110b8bd-1411-4a92-81b7-1a76f5d5cb65@SG2EHSMHS005.ehs.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, John Linn wrote:

> I have a kernel that runs fine 

What kernel exactely?

>with a busybox root file system using
> inittab.  When I move to a non-busybox init (sysvinit), I see init
> hanging when doing a close of standard error very early when it starts.
> I have debugged it with GDB but not found the source of the hang as it's
> in the kernel it appears.
> 
> To debug this, I use init=/bin/sh on the kernel command line, then exec
> init to start it. The same root file system works on another board with
> a different kernel. 

What other kernel version exactely?

> I have also noticed that building init with
> INITDEBUG on so that it forks for debugging makes it work fine. This
> seems to indicate the device nodes are all fine to me.
> 
> It seems related to PID 1 and the console device.
> 
> Adding debug to the kernel in sys_close() shows it hanging in
> filp_close() and I'm still digging more (maybe locking issue). The
> console is a serial device with a newer driver which I suspected to be
> the issue, but can't see anything wrong.
> 
> Any hints or similar problems seen would be much appreciated.
> Thanks,
> John
> 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

