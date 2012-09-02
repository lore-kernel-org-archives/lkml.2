Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2IBUuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:50:24 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:43806 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2IBUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:50:23 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2012 16:50:23 EDT
Date: Sun, 2 Sep 2012 16:42:50 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru,
        klmckinney1@gmail.com
Subject: Re: [PATCH] staging: bcm: use pr_info and pr_err rather than printk
Message-ID: <20120902204248.GC3952@gmail.com>
References: <1346614214-14340-1-git-send-email-khoroshilov@ispras.ru>
 <1346614214-14340-2-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346614214-14340-2-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 11:30:14PM +0400, Alexey Khoroshilov wrote:
> Convert printk(KERN_INFO to pr_info( and printk(KERN_ERR to pr_err(.
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/bcm/InterfaceInit.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
> index 57452ef..dfee0ce 100644
> --- a/drivers/staging/bcm/InterfaceInit.c
> +++ b/drivers/staging/bcm/InterfaceInit.c
> @@ -671,18 +671,18 @@ static __init int bcm_init(void)

Acked-by: Kevin McKinney <klmckinney1@gmail.com>
