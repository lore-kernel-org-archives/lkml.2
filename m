Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0DTKKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:10:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60357 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0DTKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VlnUAmIcGpMLEznZ+BskJlOMOsVg3THUnol0z+RucDkfKs2BQlVAXP0vTcGJ2+sZ/+
         ntkazQh6V7heICZyliQlIhQFSgjLIwqxJ8SygogxnbZ/c5BT4nObWecwh9ZsgATYouWz
         AvIoU2T5hb8+Hh2XzroK/3FCV2CQse7P8226M=
Date: Tue, 20 Apr 2010 18:14:06 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 5/5] uml: Clean up asm/system.h
Message-ID: <20100420101406.GD5317@cr0.nay.redhat.com>
References: <cover.1271713955.git.jan.kiszka@web.de>
 <e89d636e305d095f5919c0e22cf92159c4067018.1271713955.git.jan.kiszka@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e89d636e305d095f5919c0e22cf92159c4067018.1271713955.git.jan.kiszka@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 11:53:08PM +0200, Jan Kiszka wrote:
>Remove duplicates and unused prototypes.
>
>Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> arch/um/include/asm/system.h |    3 ---
> 1 files changed, 0 insertions(+), 3 deletions(-)
>
>diff --git a/arch/um/include/asm/system.h b/arch/um/include/asm/system.h
>index 753346e..93af1cf 100644
>--- a/arch/um/include/asm/system.h
>+++ b/arch/um/include/asm/system.h
>@@ -3,11 +3,8 @@
> 
> #include "sysdep/system.h"
> 
>-extern void *switch_to(void *prev, void *next, void *last);
>-
> extern int get_signals(void);
> extern int set_signals(int enable);
>-extern int get_signals(void);
> extern void block_signals(void);
> extern void unblock_signals(void);
> 
>-- 
>1.6.0.2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
