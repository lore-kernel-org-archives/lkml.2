Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1JTMhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 08:37:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42080 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1JTMhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 08:37:19 -0400
Date: Thu, 20 Oct 2011 14:37:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH ] ide-{cd,floppy,tape}: Do not include <linux/irq.h>
Message-ID: <20111020123714.GB28316@gere.osrc.amd.com>
References: <1319112675-27523-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1319112675-27523-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 02:11:15PM +0200, Geert Uytterhoeven wrote:
> The top of <linux/irq.h> has this comment:
> 
>  * Please do not include this file in generic code.  There is currently
>  * no requirement for any architecture to implement anything held
>  * within this file.
>  *
>  * Thanks. --rmk
> 
> Remove inclusion of <linux/irq.h>, to prevent the following compile error
> from happening soon:
> 
> | include/linux/irq.h:132: error: redefinition of ‘struct irq_data’
> | include/linux/irq.h:286: error: redefinition of ‘struct irq_chip’
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-ide@vger.kernel.org

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
Boris.
