Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1GQJSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:18:11 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56150 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab1GQJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:18:07 -0400
X-Sasl-enc: 3IDhYrlgAy+6gZbAV5bNB/wyUqOvVnpkq1FYzBOdYToh 1310894285
Date: Sun, 17 Jul 2011 11:13:21 +0200
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20110717091321.GA25824@kroah.com>
References: <20110716231800.62389022e6eef4b3456db52e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716231800.62389022e6eef4b3456db52e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 11:18:00PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> In file included from drivers/staging/gma500/backlight.c:23:0:
> drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such file or directory
> In file included from drivers/staging/gma500/accel_2d.c:39:0:
> drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such file or directory
> In file included from drivers/staging/gma500/gem.c:29:0:
> drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such file or directory
> In file included from drivers/staging/gma500/framebuffer.c:36:0:
> drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such file or directory
> In file included from drivers/staging/gma500/gtt.c:23:0:
> drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such file or directory
> In file included from drivers/staging/gma500/intel_bios.c:24:0:
> drivers/staging/gma500/psb_drv.h:34:22: fatal error: medfield.h: No such file or directory
> 
> Caused by commit 3caa89e93364 ("gma500: resync with Medfield progress").
> 
> I have used the staging tree from next-20110707 for today.

This should now be fixed.

thanks,

greg k-h
