Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1FNLOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:14:49 -0400
Received: from rackplans.net ([209.44.101.17]:50241 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752952Ab1FNLOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:14:47 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 07:14:47 EDT
Date: Tue, 14 Jun 2011 07:07:51 -0400 (EDT)
From: gmack@innerfire.net
X-X-Sender: gmack@mtl.rackplans.net
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc3
In-Reply-To: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106140625180.31269@mtl.rackplans.net>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011, Linus Torvalds wrote:

> I'm including the shortlog, which is fairly self-explanatory: small
> random changes, nothing hugely interesting. It will matter to people
> only if it happens to fix that one small nagging issue you had.
> 
> But as usual, I'll ask people to give it a good testing,
> 
>                        Linus


Breaks modules_install, as far as I can see it is creating the right 
folders but not putting the actual files into them.  

  INSTALL arch/x86/crypto/aes-i586.ko
cp: cannot stat `arch/x86/crypto/aes-i586.ko': No such file or directory
  INSTALL arch/x86/crypto/crc32c-intel.ko
cp: cannot stat `arch/x86/crypto/crc32c-intel.ko': No such file or 
directory
  INSTALL arch/x86/crypto/salsa20-i586.ko

etc ...

ls -l /lib/modules/3.0.0-rc3/kernel/arch/x86/
total 0
drwxr-xr-x 1 root root 0 Jun 14 13:05 crypto
drwxr-xr-x 1 root root 0 Jun 14 13:05 kernel

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer, I find your faith in technology amusing.
