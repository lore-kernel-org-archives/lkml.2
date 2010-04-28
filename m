Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab0D1ShH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:37:07 -0400
Received: from kroah.org ([198.145.64.141]:38327 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab0D1Sgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:36:52 -0400
Date: Wed, 28 Apr 2010 11:29:23 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH 12/13] drivers/staging/vt6656: Hoist assign from if
Message-ID: <20100428182923.GG8509@kroah.com>
References: <cover.1269493047.git.joe@perches.com>
 <240e36e730594a738eaeb0144c80051f585cda7a.1269493047.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <240e36e730594a738eaeb0144c80051f585cda7a.1269493047.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:17:06PM -0700, Joe Perches wrote:
> @@ -718,7 +724,8 @@ PIPEnsSendBulkOut(
>          		s_nsBulkOutIoCompleteWrite,
>          		pContext);
>  
> -    	if((status = usb_submit_urb(pUrb, GFP_ATOMIC))!=0)
> +    	status = usb_submit_urb(pUrb, GFP_ATOMIC);
> +    	if (status!=0)

And again...

