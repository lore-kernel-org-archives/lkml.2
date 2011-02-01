Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1BAMYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:24:31 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:37902 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1BAMYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:24:30 -0500
Date: Tue, 1 Feb 2011 13:23:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Timo von Holtz <tvh@informatik.uni-kiel.de>
Cc: gregkh@suse.de, mchehab@redhat.com, d.belimov@gmail.com,
        stefan.ringel@arcor.de, michel.ludwig@gmail.com,
        c.pascoe@itee.uq.edu.au, ruslan@rpisarev.org.ua,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: tm6000: fixed some coding style issues
Message-ID: <20110201132359.4f4f9e89@endymion.delvare>
In-Reply-To: <1296559341-24438-1-git-send-email-tvh@informatik.uni-kiel.de>
References: <1296559341-24438-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Timo,

On Tue,  1 Feb 2011 12:22:21 +0100, Timo von Holtz wrote:
> Fixed all of the following coding style issues:
> 
> ERROR: return is not a function, parentheses are not required
> WARNING: __func__ should be used instead of gcc specific __FUNCTION__

You messed up and replaced with __func instead of __func__.

> ERROR: trailing whitespace
> ERROR: spaces required around that '=' (ctx:VxV)
> WARNING: please, no space before tabs
> WARNING: please, no spaces at the start of a line
> ERROR: space required after that ',' (ctx:VxV)
> WARNING: space prohibited between function name and open parenthesis '('
> ERROR: spaces required around that '<' (ctx:VxV)
> ERROR: spaces required around that '==' (ctx:VxV)
> 
> Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
> ---
>  drivers/staging/tm6000/tm6000-alsa.c     |    6 +++---
>  drivers/staging/tm6000/tm6000-core.c     |    4 ++--
>  drivers/staging/tm6000/tm6000-dvb.c      |   10 +++++-----
>  drivers/staging/tm6000/tm6000-i2c.c      |    2 +-
>  drivers/staging/tm6000/tm6000-regs.h     |    2 +-
>  drivers/staging/tm6000/tm6000-usb-isoc.h |    2 +-
>  drivers/staging/tm6000/tm6000-video.c    |   28 ++++++++++++++--------------
>  drivers/staging/tm6000/tm6000.h          |    4 ++--
>  8 files changed, 29 insertions(+), 29 deletions(-)
> (...)
> --- a/drivers/staging/tm6000/tm6000-usb-isoc.h
> +++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
> @@ -46,5 +46,5 @@ struct usb_isoc_ctl {
>  	int				tmp_buf_len;
>  
>  		/* Stores already requested buffers */
> -	struct tm6000_buffer    	*buf;
> +	struct tm6000_buffer	*buf;

You want one more tab to keep the struct elements aligned.

Other than that, this patch looks mostly good.

-- 
Jean Delvare
