Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1EWQpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:45:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34018 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1EWQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kUVvPpriCqPf92hZlm5vBtZAWVPIt4xcXRH24KjUHCmoZREiUOvDNX06nWwTkTw4Nh
         lMju/B5mGQB2gQegyNLM44iXy5JZa7rSejosnAPSm8wZbVdMoh62sU5e78r0DxIrpMJQ
         tRMvILq+ow62RHueB46jrzOQFHA1G847tDK+A=
Date: Mon, 23 May 2011 09:45:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: anish singh <anish198519851985@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, arnaud.patard@rtp-net.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: s3c2410_ts.c move to threaded_irq?
Message-ID: <20110523164502.GB20397@core.coreip.homeip.net>
References: <BANLkTikwHU-RhbPp0Xwni7zKU68g6L522A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikwHU-RhbPp0Xwni7zKU68g6L522A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 01:18:59PM +0530, anish singh wrote:
> Will it be ok if i move this driver(drivers/input/touchscreen/s3c2410_ts.c)
> to threaded_irq?As we know there are some inherent advantages in moving
> to threaded_irq.
> 

I would not make such a blanket statement. Threaded interrupts are very
beneficial in some situations and godsend in others but regular
interrupts have their users too. It all depends on the device and the
driver.

Thanks.

-- 
Dmitry
