Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2BJFeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:34:25 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54971 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab2BJFeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:34:23 -0500
X-Sasl-enc: BeVE317XfnAKTapv/OCPibQHq9P0iDoHBMHAWt2f8WNv 1328852062
Date: Thu, 9 Feb 2012 21:29:47 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20120210052947.GA2068@kroah.com>
References: <20120210155800.ccef418fd5c2f2b87a5d6315@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210155800.ccef418fd5c2f2b87a5d6315@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 03:58:00PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/ramster/ramster_o2net.c: In function 'ramster_remote_async_get_request_handler':
> drivers/staging/ramster/ramster_o2net.c:91:2: error: implicit declaration of function 'o2net_force_data_magic' [-Werror=implicit-function-declaration]
> drivers/staging/ramster/ramster_o2net.c: In function 'ramster_remote_put':
> drivers/staging/ramster/ramster_o2net.c:250:2: error: implicit declaration of function 'o2net_nn_from_num' [-Werror=implicit-function-declaration]
> drivers/staging/ramster/zcache-main.c:40:64: fatal error: ../zram/xvmalloc.h: No such file or directory
> 
> Caused by commits ba351b02ab11 ("staging: ramster: local compression +
> tmem") and 14a3cd58dd4f ("staging: ramster: ramster-specific new files").
> 
> I have used the version of the staging tree from next-20120209 for today.

Ugh, I wonder why it builds here, very odd.

Dan, care to send me a patch to fix this?

greg k-h
