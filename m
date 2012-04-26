Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2DZJBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:01:30 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12439 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2DZJB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:01:29 -0400
Date: Thu, 26 Apr 2012 11:01:26 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        trivial@kernel.org, Xi Wang <xi.wang@gmail.com>,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 2/3] staging: vt6656: remove redundant parentheses from
 ioctl.c
In-Reply-To: <20120424183516.GA31247@kroah.com>
Message-ID: <alpine.LNX.2.00.1204261101170.17717@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204212156260.25551@swampdragon.chaosbits.net> <alpine.LNX.2.00.1204212203030.25551@swampdragon.chaosbits.net> <20120424183516.GA31247@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012, Greg Kroah-Hartman wrote:

> On Sat, Apr 21, 2012 at 10:04:37PM +0200, Jesper Juhl wrote:
> > I seriously doubt that anyone is confused about the precedence rules
> > for "*" and "+" - remove redundant extra parentheses.
> 
> You never really know, and as such, I'd prefer to just leave this as-is.
> 
Fair enough :)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

