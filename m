Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0ERVpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:45:32 -0400
Received: from kroah.org ([198.145.64.141]:50295 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab0ERVpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:45:30 -0400
Date: Tue, 18 May 2010 14:38:52 -0700
From: Greg KH <greg@kroah.com>
To: Morgan Gatti <morgan.gatti@gmail.com>
Cc: gregkh@suse.de, ak@linux.intel.com, kevin.granade@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sjakub@gmail.com
Subject: Re: [PATCH 2/2] Staging:asus_oled:fix style issue in assus_oled.c
Message-ID: <20100518213852.GA18525@kroah.com>
References: <1274017021-2727-1-git-send-email-morgan.gatti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274017021-2727-1-git-send-email-morgan.gatti@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 03:37:01PM +0200, Morgan Gatti wrote:
> This is a patch to the assus_oled.c file that fix the space and tabs errors founded
> by the checkpatch.pl tool
> Signed-off-by: Morgan Gatti <morgan.gatti@gmail.com>
> ---
>  drivers/staging/asus_oled/asus_oled.c |    2 +-

Sorry, but this patch has already been sent in and applied to the tree.
Try making patches against the linux-next tree instead of Linus's tree
to prevent from doing duplicate work.

thanks,

greg k-h
