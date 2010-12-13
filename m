Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab0LMV2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:28:35 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21108 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab0LMV2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:28:34 -0500
Date: Mon, 13 Dec 2010 22:22:11 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Hank Janssen <hjanssen@microsoft.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Ky Srinivasan <ksrinivasan@novell.com>
Subject: Re: [PATCH 1/1] hv: Use only one txf buffer per channel and kmalloc
 on initialize
In-Reply-To: <1292274861-29673-1-git-send-email-hjanssen@microsoft.com>
Message-ID: <alpine.LNX.2.00.1012132220220.26491@swampdragon.chaosbits.net>
References: <1292274861-29673-1-git-send-email-hjanssen@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Hank Janssen wrote:

> Correct issue with not checking kmalloc return value.
> This fix now only uses one receive buffer for all hv_utils 
> channels, and will do only one kmalloc on init and will return
> with a -ENOMEM if kmalloc fails on initialize.
> 
> And properly clean up memory on failure.
> 
> Thanks to Evgeniy Polyakov <zbr@ioremap.net> for pointing this out.
> And thanks to Jesper Juhl <jj@chaosbits.net> and Ky Srinivasan 
> <ksrinivasan@novell.com> for suggesting a better implementation of
> my original patch.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: Jesper Juhl <jj@chaosbits.net>
> Cc: Ky Srinivasan <ksrinivasan@novell.com>
> 

I can't spot any problems with these changes now, so feel free to add
  Reviewed-by: Jesper Juhl <jj@chaosbits.net>
if you like.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

