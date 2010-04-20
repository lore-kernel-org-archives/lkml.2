Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0DTI2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:28:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57287 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0DTI2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MRuGNCsSTpil4CBdfY9VQH61MWd296h39Yx1O3133tDMTrtUKW8gvnUJ2aXO4cjwo6
         NZC/yRgdOKSV1lqbF120AgLW4Zcv6BDIDIRTgtgSmO3AfDWlXhKwub4OKGPoipGAUd0t
         obuHafmhvTlMOoti6vCJUQzsdVI2l21bgaU+Q=
Date: Tue, 20 Apr 2010 16:32:36 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/5] uml: Remove unused variable from line driver
Message-ID: <20100420083236.GC4356@cr0.nay.redhat.com>
References: <cover.1271713955.git.jan.kiszka@web.de>
 <f430193946dbd11791e8fb5bef2e4a8e68393828.1271713955.git.jan.kiszka@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f430193946dbd11791e8fb5bef2e4a8e68393828.1271713955.git.jan.kiszka@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 11:53:04PM +0200, Jan Kiszka wrote:
>Signed-off-by: Jan Kiszka <jan.kiszka@web.de>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> arch/um/drivers/line.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
>index 7a656bd..7f7338c 100644
>--- a/arch/um/drivers/line.c
>+++ b/arch/um/drivers/line.c
>@@ -19,7 +19,6 @@ static irqreturn_t line_interrupt(int irq, void *data)
> {
> 	struct chan *chan = data;
> 	struct line *line = chan->line;
>-	struct tty_struct *tty;
> 
> 	if (line)
> 		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
>-- 
>1.6.0.2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
