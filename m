Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750877Ab0KVFN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 00:13:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:30240 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0KVFN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 00:13:28 -0500
Date: Sun, 21 Nov 2010 21:13:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc3 problems
Message-Id: <20101121211311.05963007.randy.dunlap@oracle.com>
In-Reply-To: <20101121205626.4589e544.randy.dunlap@oracle.com>
References: <web-407197955@zbackend1.aha.ru>
	<20101122043520.GA10958@kroah.com>
	<20101121205626.4589e544.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 20:56:26 -0800 Randy Dunlap wrote:

> On Sun, 21 Nov 2010 20:35:20 -0800 Greg KH wrote:
> 
> > On Sun, Nov 21, 2010 at 11:20:40PM -0400, werner wrote:
> > > 2.6.37-rc3 problems
> > >
> > > easycap_main.c lines 4251,4 : implicit declaration lock-kernel   ,  
> > > unlock_kernel
> > >
> > > (compilation error)
> > 
> > Either disable this driver from your .config, or enable the BKL in your
> > .config.  I have a pending patch to get to Linus to fix this Kconfig
> > issue for this driver.
> 
> The build error happens even when CONFIG_BKL=y.  In fact, that's the only
> way to enable EASYCAP, since EASYCAP depends on BKL.

OTOH, adding <linux/smp_lock.h> to easycap.h fixes the build.


> > Are you really using this driver?
> 
> Werner builds a distro.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
