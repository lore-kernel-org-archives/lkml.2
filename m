Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0LJAjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:39:45 -0500
Received: from kroah.org ([198.145.64.141]:41347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0LJAjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 19:39:44 -0500
Date: Thu, 9 Dec 2010 16:37:17 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        dmitry.kasatkin@nokia.com
Subject: Re: [PATCH 01/11] Staging: sep: remove virtual address being
 passed to user space application
Message-ID: <20101210003717.GA28530@kroah.com>
References: <1291915803-18316-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291915803-18316-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 09:30:03AM -0800, Mark Allyn wrote:
> @@ -3064,7 +3051,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		break;
>  	case SEP_IOCGETSTATICPOOLADDR:
>  		/* Get the physical and virtual addresses of the static pool */
> -		error = sep_get_static_pool_addr_handler(sep, arg);
> +		error = sep_get_static_pool_addr_handler(sep);

This comment should be changed as well, right?

thanks,

greg k-h
