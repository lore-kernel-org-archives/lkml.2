Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0DNG4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:56:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49941 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0DNG4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g940WqdO2YonG/fjxlMb6YCzVf8fs+ifvS1HyMqMoAqHCfma4oNdVIiDeYXDO+2VQ0
         XPhH3uoo203UarbFjcUtuIpfP8dlhX52tqTsKtL0/GLjzSvCnaERRBzfmI3jTnUxMQZU
         aWLbqyzoonWKCukHnEddqdex+0FfCJZ+f5Wyg=
Date: Wed, 14 Apr 2010 15:00:22 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
       dnelson@redhat.com
Subject: Re: [PATCH]: x86: remove extra bootmem.h from arch/x86/mm/init_64.c
Message-ID: <20100414070022.GA4503@cr0.nay.redhat.com>
References: <20100413154715.23179.40700.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413154715.23179.40700.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:47:15AM -0400, Prarit Bhargava wrote:
>[Resubmitting to wider audience...]
>
>bootmem.h is already included in init_64.c.  Remove the second include.
>
>Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>

Acked-by: Amerigo Wang <xiyou.wangcong@gmail.com>

Thanks!


>diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>index ee41bba..a9474fc 100644
>--- a/arch/x86/mm/init_64.c
>+++ b/arch/x86/mm/init_64.c
>@@ -50,7 +50,6 @@
> #include <asm/numa.h>
> #include <asm/cacheflush.h>
> #include <asm/init.h>
>-#include <linux/bootmem.h>
> 
> static unsigned long dma_reserve __initdata;
> 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
