Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2K0RSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:18:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36879 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2K0RSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:18:16 -0500
Date: Tue, 27 Nov 2012 09:19:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shan Wei <shanwei88@gmail.com>
Cc: benchan@chromium.org, syahn@gctsemi.com, devel@driverdev.osuosl.org,
        pstew@chromium.org, joe@perches.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] drivers: staging: remove last usage of NIPQUAD and
 NIP6 in gdm72xx
Message-ID: <20121127171938.GA17680@kroah.com>
References: <50B4277A.6080307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B4277A.6080307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 10:37:46AM +0800, Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 
> commit cf4ca4874fc45 removed the definition of NIPQUAD and NIPQUAD_FMT,
> and NIP6 also is out of date.
> 
> Because DEBUG_SDU is not defined in gdm_wimax.h, no error message when compiling
> this code. And remove constant condition judge.
> 
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---
> V3:
>    As suggestion of greg k-h's patch email bot, recreate this patch base on greg's staging tree,
>    v2 is on David Miller's net-next tree.

Are you sure you got the right branch?  This does not apply to my
staging-next branch of the staging.git tree, what did you use?

thanks,

greg k-h
