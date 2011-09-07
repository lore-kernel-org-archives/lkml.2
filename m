Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1IGA4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 20:56:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab1IGAz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 20:55:59 -0400
Date: Wed, 7 Sep 2011 10:55:43 +1000
From: NeilBrown <neilb@suse.de>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trival: md_k.h should be md.h in the beginning comment
 of file md.h
Message-ID: <20110907105543.2a502587@notabene.brown>
In-Reply-To: <4E635D74.7090808@gmail.com>
References: <4E635D74.7090808@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Sep 2011 19:13:56 +0800 Wang Sheng-Hui <shhuiw@gmail.com> wrote:

> The patch is against 3.1-rc3.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  drivers/md/md.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1e586bb..4b304ad 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -1,5 +1,5 @@
>  /*
> -   md_k.h : kernel internal structure of the Linux MD driver
> +   md.h : kernel internal structure of the Linux MD driver
>            Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
>  	  
>     This program is free software; you can redistribute it and/or modify

Thanks.  I'll go upstream in the next merge window.

NeilBrown
