Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0FYN4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:56:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49247 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab0FYN4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:56:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 8/9] PM / Hibernate: dealign swsusp_info
Date: Fri, 25 Jun 2010 15:54:46 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz> <1275468768-28229-8-git-send-email-jslaby@suse.cz>
In-Reply-To: <1275468768-28229-8-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006251554.46466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 02, 2010, Jiri Slaby wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Now there is no need to have swsusp_info page aligned thanks to chunk
> i/o support. We may add more info after it on the very same page.
> Later...

OK

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/power/power.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 6e2e796..1fdbfe7 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -12,7 +12,7 @@ struct swsusp_info {
>  	unsigned long		image_pages;
>  	unsigned long		pages;
>  	unsigned long		size;
> -} __attribute__((aligned(PAGE_SIZE)));
> +};
>  
>  #ifdef CONFIG_HIBERNATION
>  #ifdef CONFIG_ARCH_HIBERNATION_HEADER
> 

