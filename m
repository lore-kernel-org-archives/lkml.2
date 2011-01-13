Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab1AMWsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:48:42 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27193 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1AMWsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:48:36 -0500
Date: Thu, 13 Jan 2011 23:48:35 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: Tony Finch <dot@dotat.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strncpy() will not \0 terminate result
In-Reply-To: <20110113224627.GA15000@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1101132347540.11347@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101132332430.11347@swampdragon.chaosbits.net> <20110113224627.GA15000@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Wolfram Sang wrote:

> On Thu, Jan 13, 2011 at 11:35:39PM +0100, Jesper Juhl wrote:
> > Hi,
> > 
> > Mpass() in scripts/unifdef.c has this code:
> >   strncpy(keyword, "if  ", 4);
> > this will fail to \0 terminate the destination.
> > Following patch should fix that up.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Thanks for fixing those issues. If you could spend a few more seconds on the
> subject line (missing sth like "scripts/unifdef"-prefix; I initially was
> fearing the bug was in lib/string.c) and the commit-message (which reads like a
> mail), that would be helpful for reviewers.
> 
Yeah, I don't know what happened when I wrote that subject - it's quite 
bad. Sorry.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

