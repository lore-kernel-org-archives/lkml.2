Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab0CYWns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:43:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0CYWnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:43:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC 14/15] PM / Hibernate: dealign swsusp_info
Date: Thu, 25 Mar 2010 23:46:56 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: jirislaby@gmail.com, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-14-git-send-email-jslaby@suse.cz>
In-Reply-To: <1269361063-3341-14-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252346.56189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Jiri Slaby wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Now there is no need to have swsusp_info page aligned thanks to chunk
> i/o support. We may add more info after it on the very same page.
> Later...
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

Fine by me.

Rafael


> ---
>  kernel/power/power.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 842d27b..cf1450f 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -13,7 +13,7 @@ struct swsusp_info {
>  	unsigned long		image_pages;
>  	unsigned long		pages;
>  	unsigned long		size;
> -} __attribute__((aligned(PAGE_SIZE)));
> +};
>  
>  #ifdef CONFIG_HIBERNATION
>  #ifdef CONFIG_ARCH_HIBERNATION_HEADER
> 

