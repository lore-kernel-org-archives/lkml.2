Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab2ECWMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:12:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2ECWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:12:05 -0400
Date: Thu, 3 May 2012 15:12:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Davidson <md@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core: fix DEVICE_INT_ATTR to use correct
 show/store functions
Message-ID: <20120503221200.GA22903@kroah.com>
References: <20120503220747.7B1E88095E@fiasco.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503220747.7B1E88095E@fiasco.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 03:07:47PM -0700, Michael Davidson wrote:
> [PATCH] driver-core: fix DEVICE_INT_ATTR to use correct show/store functions
> 
> DEVICE_INT_ATTR() should use device_show_int() and device_store_int()
> not device_show_ulong() and device_store_ulong()
> 
> Signed-off-by: Michael Davidson <md@google.com>
> ---
> 
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -508,7 +508,7 @@ ssize_t device_store_int(struct device *
>  		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
>  #define DEVICE_INT_ATTR(_name, _mode, _var)  	struct dev_ext_attribute dev_attr_##_name = -		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
> +		{ __ATTR(_name, _mode, device_show_int, device_store_int), &(_var) }

Something odd happened with your patch, and I can't apply it :(

Care to try again?

