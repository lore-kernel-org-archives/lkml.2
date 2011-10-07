Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935430Ab1JGUpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:45:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37017 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758996Ab1JGUpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:45:46 -0400
Message-ID: <1318020329.11045.15.camel@Joe-Laptop>
Subject: Re: [PATCH 26/26] printk.h: fix pr_cont_once() to not use pr_fmt()
From: Joe Perches <joe@perches.com>
To: jim.cromie@gmail.com
Cc: jbaron@redhat.com, greg@kroah.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Oct 2011 13:45:29 -0700
In-Reply-To: <1318019612-20068-27-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	 <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
	 <1318019612-20068-27-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 14:33 -0600, jim.cromie@gmail.com wrote:
> diff --git a/include/linux/printk.h b/include/linux/printk.h
[]
> @@ -255,7 +255,7 @@ extern void dump_stack(void) __cold;
>  #define pr_info_once(fmt, ...)					\
>  	printk_once(KERN_INFO pr_fmt_info(fmt), ##__VA_ARGS__)
>  #define pr_cont_once(fmt, ...)					\
> -	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
> +	printk_once(KERN_CONT fmt, ##__VA_ARGS__)

As this is unused and defective, I think it'd be better
to remove it instead.


