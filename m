Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936527Ab0COO2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:28:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936454Ab0COO2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:28:11 -0400
Date: Mon, 15 Mar 2010 15:28:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: [PATCH] KOBJECTS:  kref.h incorrectly describes itself as
 kref.c.
In-Reply-To: <alpine.LFD.2.00.1003130756060.8626@localhost>
Message-ID: <alpine.LNX.2.00.1003151527590.18642@pobox.suse.cz>
References: <alpine.LFD.2.00.1003130756060.8626@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010, Robert P. J. Day wrote:

> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
> diff --git a/include/linux/kref.h b/include/linux/kref.h
> index b0cb0eb..baf4b9e 100644
> --- a/include/linux/kref.h
> +++ b/include/linux/kref.h
> @@ -1,5 +1,5 @@
>  /*
> - * kref.c - library routines for handling generic reference counted objects
> + * kref.h - library routines for handling generic reference counted objects
>   *
>   * Copyright (C) 2004 Greg Kroah-Hartman <greg@kroah.com>
>   * Copyright (C) 2004 IBM Corp.

I have picked this one up.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
