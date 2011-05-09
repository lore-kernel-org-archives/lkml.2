Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1EIWxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:53:33 -0400
Received: from kroah.org ([198.145.64.141]:44609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767Ab1EIWxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:53:32 -0400
Date: Mon, 9 May 2011 15:53:28 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 077/206] Staging: hv: Get rid of call to cleanup()
Message-ID: <20110509225328.GA2832@kroah.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-77-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304978288-22999-77-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 02:55:59PM -0700, K. Y. Srinivasan wrote:
> cleanup() is an empty function; get rid of it.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/netvsc_drv.c |    4 ----

Just picking a random patch out of this series (which, I only received
the first 132, not all 206).

You need to specify a better changelog entry as you didn't say what code
you are changing in the Subject:.

How about:
	Staging: hv: netvsc_drv: Get rid of call to cleanup()

Otherwise I would think (and I did) that you got rid of a global
function called cleanup() in all of the hv code.

Care to fix the names of your patches?

Note, I wouldn't recommend sending that many patches to lkml, it's not
needed, just stick to the devel@linuxdriverproject.org list as I really
doubt anyone else cares about this code at the moment.

thanks,

greg k-h
