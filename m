Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab0IQQhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:37:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab0IQQhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:37:54 -0400
Date: Fri, 17 Sep 2010 09:32:27 -0700
From: Greg KH <gregkh@suse.de>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: shijie8@gmail.com, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.4+current stable queue: hangs at boot, bisected
Message-ID: <20100917163227.GA31409@suse.de>
References: <AANLkTi=pxciY2jJePYPDzaRjsyGo3pQTeip0AJSqrzzh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=pxciY2jJePYPDzaRjsyGo3pQTeip0AJSqrzzh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 05:07:20PM +0200, Giangiacomo Mariotti wrote:
> Hi,
>     Linux kernel 2.6.35.4+patches in stable-queue hangs at boot, right
> after selecting it on grub. The cursor blinks and there's no output
> whatsoever. I've bisected the problem to the patch
> "percpu-fix-a-memory-leak-in-pcpu_extend_area_map.patch". Without it
> and applying all the others, the kernel works again. If you need more
> info, let me know.

Yes, thanks, 3 other people just hit and reported this as well :)

I'll go drop that patch from the queue right now, I just got back to my
desk...

thanks for testing and letting me know.

greg k-h
