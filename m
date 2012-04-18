Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2DRWVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:21:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23815 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2DRWVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:21:39 -0400
Date: Thu, 19 Apr 2012 00:21:36 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        devel@driverdev.osuosl.org, Xi Wang <xi.wang@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH][Trivial] staging: vt6656: Remove some redundant casts
 and parentheses + other style cleanups
In-Reply-To: <1334694212.1909.4.camel@joe2Laptop>
Message-ID: <alpine.LNX.2.00.1204190020210.14916@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204162314480.21898@swampdragon.chaosbits.net> <1334694212.1909.4.camel@joe2Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Joe Perches wrote:

> On Mon, 2012-04-16 at 23:20 +0200, Jesper Juhl wrote:
> > This is just a small/trivial cleanup patch. It makes the following
> > changes to drivers/staging/vt6656/ioctl.c:
> > 
> > 1. Remove some redundant casts.
> 
> drivers/staging/vt6656/wcmd.h:BOOL bScheduleCommand(void *hDeviceContext,
> 
> so you could remove the casts of the first argument too.
> 
Thank you for the review Joe. 
I'll get an updated patch together some time tomorrow.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

