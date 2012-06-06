Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab2FFTBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:01:15 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33414 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2FFTBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:01:13 -0400
From: Oliver Neukum <oliver@neukum.org>
To: stefani@seibold.net
Subject: Re: [PATCH 02/11] code cleanup
Date: Wed, 6 Jun 2012 20:57:59 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
References: <1339000032-10313-1-git-send-email-stefani@seibold.net> <1339000032-10313-3-git-send-email-stefani@seibold.net>
In-Reply-To: <1339000032-10313-3-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206062058.00020.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Juni 2012, 18:27:03 schrieb stefani@seibold.net:
> From: Stefani Seibold <stefani@seibold.net>
> 
> - consistent nameing
> - more compact style
> - remove unneeded code
> 

>  static int skel_flush(struct file *file, fl_owner_t id)
>  {
> -	struct usb_skel *dev;
> +	struct usb_skel *dev = file->private_data;
>  	int res;
>  
> -	dev = file->private_data;
> -	if (dev == NULL)
> -		return -ENODEV;
> -

flush() is intended to report errors. A check for disconnect is needed.

	Regards
		Oliver
