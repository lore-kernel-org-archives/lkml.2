Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0KJAqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:46:43 -0500
Received: from kroah.org ([198.145.64.141]:48910 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0KJAql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:46:41 -0500
Date: Tue, 9 Nov 2010 16:45:43 -0800
From: Greg KH <greg@kroah.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        devel@driverdev.osuosl.org, Dan Carpenter <error27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 10/17][trivial] staging, bcm: Remove unnecessary casts
 of void ptr returning alloc function return values
Message-ID: <20101110004543.GA28373@kroah.com>
References: <alpine.LNX.2.00.1011082342560.23697@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011082342560.23697@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:09:51AM +0100, Jesper Juhl wrote:
> Hi,
> 
> The [vk][cmz]alloc(_node) family of functions return void pointers which
> it's completely unnecessary/pointless to cast to other pointer types since
> that happens implicitly.
> 
> This patch removes such casts from drivers/staging/bcm/
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  CmHost.c       |    2 +-
>  InterfaceDld.c |   27 +++++++++++++--------------
>  Misc.c         |   12 +++++-------
>  3 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c

This driver just got a major overhaul, and this patch doesn't apply
anymore.

Care to redo it against the next linux-next tree?

thanks,

greg k-h
