Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0KGIDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 03:03:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41175 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0KGIDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 03:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M2d4MeoMvZO2T9ZhgA/tn+40Cf1pGG6qzbIznW1B+i3Q4X6vKHWA8tLVrfyTeRJ1vH
         VD+C6xwADanGs37B6vzsrWkql2cO04Io+MZMSVzRsVIAMsYv4rSLwXYsV6OO1cpNpstr
         aFg3yOgCPmbzmrBD4zE2fDTszTX00usIF9qqA=
Date: Sun, 7 Nov 2010 16:06:48 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Anders Kaseorg <andersk@ksplice.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH] module: Update prototype for ref_module (formerly
	use_module)
Message-ID: <20101107080648.GN3046@hack>
References: <alpine.DEB.2.00.1011051702090.3947@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011051702090.3947@dr-wily.mit.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 05:05:46PM -0400, Anders Kaseorg wrote:
>Commit 9bea7f23952d5948f8e5dfdff4de09bb9981fb5f renamed use_module to
>ref_module (and changed its return value), but forgot to update this
>prototype in module.h.
>
>Signed-off-by: Anders Kaseorg <andersk@ksplice.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

I am wondering why we find this after 5 months! :-/

>---
> include/linux/module.h |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index aace066..caf6105 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -514,7 +514,7 @@ static inline void __module_get(struct module *module)
> #define symbol_put_addr(p) do { } while(0)
> 
> #endif /* CONFIG_MODULE_UNLOAD */
>-int use_module(struct module *a, struct module *b);
>+int ref_module(struct module *a, struct module *b);
> 
> /* This is a #define so the string doesn't get put in every .o file */
> #define module_name(mod)			\
>-- 
>1.7.3.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
