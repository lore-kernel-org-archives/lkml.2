Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2LNJJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:09:04 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47681 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2LNJI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:08:58 -0500
Date: Fri, 14 Dec 2012 03:08:54 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [git pull] m68k updates for 3.8
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1212132040040.14664@ayla.of.borg> (from
	geert@linux-m68k.org on Thu Dec 13 13:44:14 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1355476134.18402.5@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 01:44:14 PM, Geert Uytterhoeven wrote:
> 	Hi Linus,
> 
> The following changes since commit  
> 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:
>   Linus Torvalds (1):
>         Linux 3.7

Query: what's your test environment?

I've been trying to get m68k linux to boot in qemu on and off for years  
(http://landley.net/aboriginal/bin/system-image-m68k.tar.bz2), but qemu  
seems to be missing bits (mmu stuff mostly, some work's being done at  
git://gitorious.org/qemu-m68k/qemu-m68k especially in the q800 branch,  
but it throws a double MMU fault during kernel boot).

Somebody got one of my images to boot under aranym but they had to  
patch the kernel fairly extensively to add the emulated device support  
that emulator provided. It doesn't emulate real devices the way qemu  
does, but qemu doesn't fully emulate the processor (just coldfire in  
mainline)...

Rob