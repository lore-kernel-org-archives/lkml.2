Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0D1Sgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:36:50 -0400
Received: from kroah.org ([198.145.64.141]:38303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0D1Sgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:36:48 -0400
Date: Wed, 28 Apr 2010 11:20:32 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 02/13] drivers/staging/dt3155: Hoist assign from if
Message-ID: <20100428182032.GA8509@kroah.com>
References: <cover.1269493047.git.joe@perches.com>
 <4c48eda8f1057b8911e16c4bcc3bac0c87855e12.1269493047.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c48eda8f1057b8911e16c4bcc3bac0c87855e12.1269493047.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:16:56PM -0700, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/dt3155/dt3155_drv.c |   20 ++++++++++++--------
>  drivers/staging/dt3155/dt3155_isr.c |    3 ++-

This doesn't apply anymore to linux-next, care to respin it?

thanks,

greg k-h
