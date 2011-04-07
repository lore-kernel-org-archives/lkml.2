Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1DGQb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:31:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1DGQb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:31:56 -0400
Date: Thu, 7 Apr 2011 09:22:43 -0700
From: Greg KH <gregkh@suse.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers:staging:hv:hv_mouse.c Fix build error in hv_mouse.
Message-ID: <20110407162243.GA31002@suse.de>
References: <1302186996-23392-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302186996-23392-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 07:36:36AM -0700, Justin P. Mattock wrote:
> The patch below fixes a build error..
> 
>   LD [M]  drivers/staging/hv/hv_utils.o
>   CC [M]  drivers/staging/hv/hv_mouse.o
> drivers/staging/hv/hv_mouse.c: In function ‘ReleaseInputDevice’:
> drivers/staging/hv/hv_mouse.c:293:3: error: implicit declaration of function ‘udelay’ [-Werror=implicit-function-declaration]
> drivers/staging/hv/hv_mouse.c: In function ‘MousevscOnReceiveInputReport’:
> drivers/staging/hv/hv_mouse.c:418:27: warning: variable ‘inputDriver’ set but not used [-Wunused-but-set-variable]
> drivers/staging/hv/hv_mouse.c: In function ‘MousevscOnDeviceAdd’:
> drivers/staging/hv/hv_mouse.c:663:27: warning: variable ‘inputDriver’ set but not used [-Wunused-but-set-variable]
> cc1: some warnings being treated as errors
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/staging/hv/hv_mouse.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Thanks, but this is already in the linux-next tree and will go to Linus
in a few hours.

greg k-h
