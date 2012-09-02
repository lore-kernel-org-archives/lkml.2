Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2IBUio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:38:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42491 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2IBUin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:38:43 -0400
Date: Sun, 2 Sep 2012 16:38:26 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH v2] staging: bcm: fix error handling in bcm_init()
Message-ID: <20120902203823.GB3952@gmail.com>
References: <20120902165130.GA3952@gmail.com>
 <1346614214-14340-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346614214-14340-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 11:30:13PM +0400, Alexey Khoroshilov wrote:
> bcm_init() does not have proper error handling of usb_register().
> The patch implements one.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/bcm/InterfaceInit.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
> index 8f85de6..57452ef 100644
> --- a/drivers/staging/bcm/InterfaceInit.c
> +++ b/drivers/staging/bcm/InterfaceInit.c
> @@ -669,6 +669,8 @@ struct class *bcm_class;
>  
Acked-by: Kevin McKinney <klmckinney1@gmail.com>
