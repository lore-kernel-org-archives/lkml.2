Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0GKWVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 18:21:50 -0400
Received: from xenotime.net ([72.52.115.56]:51070 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754753Ab0GKWVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 18:21:49 -0400
Date: Sun, 11 Jul 2010 15:21:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: werner@guyane.yi.org
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
Message-Id: <20100711152141.973a8280.rdunlap@xenotime.net>
In-Reply-To: <1278727932.27193@guyane.yi.org>
References: <1278727932.27193@guyane.yi.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jul 2010 23:12:12 -0300 (GFT) werner@guyane.yi.org wrote:

> Yes with switching that off as dmitry said, it returns to work.
> 
> On the other hand,  I make a distro, SYS, and for distros it's necessary to enable EVERYTHING,
> for compiling the kernel,
> because you never know what computer people have.   Thus, generally, modules have to be programmed
> in a manner that a kernel also works if you don't have certain hardware.  
> 
> This should be corrected in that module -- so that the kernel runs also on my computer
> (and on other people computer) when the kernel is compiled with the option enabled.

Patches have already been posted for a more permanent fix that allows a distro
to enable X86_MRST.

> At meast, for me at the moment it works with disable the hardware.
> 
> The bin package, Slackware-compatible, for my SYS distro, I put here: ftp://ftp.uni-siegen.de/pub/sys-linux  under linux-2.6.35-rc4-git4 ...


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
