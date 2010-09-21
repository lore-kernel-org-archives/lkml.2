Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0IUQLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:11:37 -0400
Received: from mail.perches.com ([173.55.12.10]:2198 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab0IUQLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:11:36 -0400
Subject: Re: [PATCH 10/11] drivers/usb/gadget: Remove pr_<level> uses of
 KERN_<level>
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <141dd5ea20749b4b37d60cae53d1751bb88ba15c.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
	 <141dd5ea20749b4b37d60cae53d1751bb88ba15c.1284267142.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 09:11:34 -0700
Message-ID: <1285085494.6816.0.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 22:10 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/usb/gadget/r8a66597-udc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
> index 2456ccd..8040c85 100644
> --- a/drivers/usb/gadget/r8a66597-udc.c
> +++ b/drivers/usb/gadget/r8a66597-udc.c
> @@ -274,7 +274,7 @@ static int pipe_buffer_setting(struct r8a66597 *r8a66597,
>  	}
>  
>  	if (buf_bsize && ((bufnum + 16) >= R8A66597_MAX_BUFNUM)) {
> -		pr_err(KERN_ERR "r8a66597 pipe memory is insufficient\n");
> +		pr_err("r8a66597 pipe memory is insufficient\n");
>  		return -ENOMEM;
>  	}
>  

Ping?

