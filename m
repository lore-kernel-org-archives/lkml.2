Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab0JHOYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:24:30 -0400
Received: from kroah.org ([198.145.64.141]:35622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab0JHOY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:24:29 -0400
Date: Fri, 8 Oct 2010 07:24:34 -0700
From: Greg KH <greg@kroah.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 27/33] Staging: ti-st: Makefile: replace the use of
	<module>-objs with <module>-y
Message-ID: <20101008142434.GA23666@kroah.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com> <1286496113-11897-27-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286496113-11897-27-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 08:01:47PM -0400, Tracey Dent wrote:
> Changed <module>-objs to <module>-y in Makefile.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/ti-st/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/ti-st/Makefile b/drivers/staging/ti-st/Makefile
> index 0167d1d..4b6ca18 100644
> --- a/drivers/staging/ti-st/Makefile
> +++ b/drivers/staging/ti-st/Makefile
> @@ -3,5 +3,5 @@
>  # and its protocol drivers (BT, FM, GPS)
>  #
>  obj-$(CONFIG_TI_ST) 		+= st_drv.o
> -st_drv-objs			:= st_core.o st_kim.o st_ll.o
> +st_drv-y			:= st_core.o st_kim.o st_ll.o
>  obj-$(CONFIG_ST_BT) 		+= bt_drv.o

For some odd reason, this patch didn't apply to the tree, but all of the
32 other patches in the series did.  Care to redo this one and resend it
to me?

thanks,

greg k-h
