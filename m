Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1HFTGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 15:06:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab1HFTGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 15:06:06 -0400
Date: Sat, 6 Aug 2011 12:04:58 -0700
From: Greg KH <gregkh@suse.de>
To: stufever@gmail.com
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: Re: [PATCH] gma500: fix build error in
 drivers/staging/gma500/gem_glue.c
Message-ID: <20110806190458.GA3257@suse.de>
References: <1312656727-4603-1-git-send-email-wangshaoyan.pt@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312656727-4603-1-git-send-email-wangshaoyan.pt@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 02:52:07AM +0800, stufever@gmail.com wrote:
> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> 
>   LD      drivers/built-in.o
>   drivers/staging/built-in.o: In function 'drm_gem_private_object_init':
>   /home/stufever/linux-2.6/drivers/staging/gma500/gem_glue.c:30: multiple definition of 'drm_gem_private_object_init'
>   drivers/gpu/built-in.o:/home/stufever/linux-2.6/drivers/gpu/drm/drm_gem.c:160: first defined here
>   make[1]: *** [drivers/built-in.o] Error 1
>   make: *** [drivers] Error 2
> 
> The function drm_gem_private_object_init had been EXPORT_SYMBOL at drivers/gpu/drm/drm_gem.c, so delete repeated code.
> 
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>

Thanks, but this is already in linux-next and will be sent to Linus
after 3.2-rc1 is out.

thanks,

greg k-h
