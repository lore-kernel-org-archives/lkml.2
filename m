Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1HPJL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 05:11:29 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:36644 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1HPJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 05:11:26 -0400
Date: Tue, 16 Aug 2011 11:11:43 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.2
In-Reply-To: <20110816015501.GB28885@kroah.com>
Message-ID: <alpine.LNX.2.00.1108161110350.23471@swampdragon.chaosbits.net>
References: <20110816015447.GA28885@kroah.com> <20110816015501.GB28885@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/Makefile b/Makefile
> index f124b18..794fa28 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,6 +1,6 @@
>  VERSION = 3
>  PATCHLEVEL = 0
> -SUBLEVEL = 1
> +SUBLEVEL = 2
>  EXTRAVERSION =

Isn't it time we remove that EXTRAVERSION from the stable kernels now that 
they are using SUBLEVEL ?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

