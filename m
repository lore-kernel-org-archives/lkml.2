Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab2CZS7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:59:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42141 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab2CZS7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:59:20 -0400
Date: Mon, 26 Mar 2012 13:59:12 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 26 (platform/x86/apple-gmux)
Message-ID: <20120326185912.GD17126@thinkpad-t410>
Mail-Followup-To: Randy Dunlap <rdunlap@xenotime.net>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org
References: <20120326152807.debdb1ec426b3c370c121178@canb.auug.org.au>
 <4F70A27D.9000706@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F70A27D.9000706@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:08:13AM -0700, Randy Dunlap wrote:
> On 03/25/2012 09:28 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Reminder: please do not add stuff destined for v3.5 to linux-next
> > included trees/branches until after v3.4-rc1 has been released.
> > 
> > Changes since 20120323:
> 
> 
> on i386:
> 
>   CC      drivers/platform/x86/apple-gmux.o
> drivers/platform/x86/apple-gmux.c: In function 'gmux_read8':
> drivers/platform/x86/apple-gmux.c:62:2: error: implicit declaration of function 'inb'
> drivers/platform/x86/apple-gmux.c: In function 'gmux_write8':
> drivers/platform/x86/apple-gmux.c:68:2: error: implicit declaration of function 'outb'
> drivers/platform/x86/apple-gmux.c: In function 'gmux_read32':
> drivers/platform/x86/apple-gmux.c:73:2: error: implicit declaration of function 'inl'
> drivers/platform/x86/apple-gmux.c: In function 'gmux_probe':
> drivers/platform/x86/apple-gmux.c:117:2: error: implicit declaration of function 'kzalloc'
> drivers/platform/x86/apple-gmux.c:117:12: warning: assignment makes pointer from integer without a cast
> drivers/platform/x86/apple-gmux.c:198:2: error: implicit declaration of function 'kfree'
> 
> 
> Full randconfig file is attached.

I get the same thing with that config. Sorry about that.

Matthew: Adding includes for linux/slab.h and asm/io.h fixes the build
for me. Do you want to fix it up in your tree, or do you want me to send
a replacement patch?

Seth

