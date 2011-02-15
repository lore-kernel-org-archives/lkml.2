Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1BOAF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:05:28 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13418 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab1BOAF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:05:27 -0500
Date: Tue, 15 Feb 2011 01:04:23 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Haiyang Zhang <haiyangz@microsoft.com>
cc: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH 2/2] staging: hv: Remove dead code from rndis_filter.c
In-Reply-To: <1297723902-18176-2-git-send-email-haiyangz@microsoft.com>
Message-ID: <alpine.LNX.2.00.1102150102440.4530@swampdragon.chaosbits.net>
References: <1297723902-18176-1-git-send-email-haiyangz@microsoft.com> <1297723902-18176-2-git-send-email-haiyangz@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Haiyang Zhang wrote:

> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/staging/hv/rndis_filter.c |   15 ---------------
>  1 files changed, 0 insertions(+), 15 deletions(-)
> 
...

I would probably have said "remove commented out code from rndis_filter.c" 
rather than "remove dead code ...", but nevermind :-)
Looks good to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

