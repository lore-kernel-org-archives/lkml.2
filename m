Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2B0VR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:17:59 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57944 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2B0VR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:17:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.125.133 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 27 Feb 2012 13:16:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Kelly <ckelly@ozmodevices.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20120227211630.GA18418@kroah.com>
References: <20120227181303.9aa93b8a8ed02428e9310c5e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227181303.9aa93b8a8ed02428e9310c5e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 06:13:03PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build
> (powerpc_allyesconfig) failed like this:
> 
> drivers/staging/ozwpan/ozcdev.c: In function 'oz_cdev_ioctl':
> drivers/staging/ozwpan/ozcdev.c:284:7: error: case label does not reduce to an integer constant
> 
> Caused by commit 23af8c2a088f ("staging: ozwpan: Added character device
> support") from the staging tree.
> 
> I reverted commit b0406db5b3e4 ("staging: ozwpan: Plumbed in Kconfig and
> Kbuild") for today.

Thanks, Chris, care to fix this up and send me a patch?

greg k-h
