Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1FUKmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:42:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63897 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1FUKl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L3/2hcQCYMdg1zaIKmAoQdJKu093ysC/ndcQNLeQWVbrROhigJ8CSkOlqy8V7Q7bW4
         hPjby3a+QsTjg7LSPJJ59VJuDDioYtny21iR3ci9S8XUSBANNxWVRJ9+lQ+Lvq9tP9+y
         /u+r702rJb/vuJtItnwcLvRtCNwHoU2LlyUHM=
Date: Tue, 21 Jun 2011 03:41:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org,
        rpurdie@rpsys.net, lethal@linux-sh.org, tglx@linutronix.de,
        buytenh@secretlab.ca, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] locomo: drop special locomo_{read/write}l in favor of
 io{read/write}16
Message-ID: <20110621104148.GB8468@core.coreip.homeip.net>
References: <201106201454.18070.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106201454.18070.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 02:54:17PM -0700, H Hartley Sweeten wrote:
> All the locomo registers are 16-bit ioremap'ed memory addresses.  
> 
> Make the locomo drivers use generic purpose io routines: ioread16
> and iowrite16 instead of directly accessing memory.
> 
> There are still a couple checkpatch warnings about lines exceeding
> 79 characters.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Input parts look good to me.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
