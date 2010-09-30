Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab0I3ROf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:14:35 -0400
Received: from kroah.org ([198.145.64.141]:52055 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab0I3ROe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:14:34 -0400
Date: Thu, 30 Sep 2010 04:13:45 -0700
From: Greg KH <greg@kroah.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: fix skb, netdev, memory leaks
Message-ID: <20100930111345.GA9978@kroah.com>
References: <1285696175-5654-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285696175-5654-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 09:49:35PM +0400, Vasiliy Kulikov wrote:
> ft1000_copy_up_pkt() doesn't free skb on errors.
> init_ft1000_card() doesn't free netdev with free_netdev() but with kfree().
> init_ft1000_card() doesn't check request_region()'s return value
> and doesn't free region on error.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.

No you didn't

>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |   32 +++++++++++++--------
>  1 files changed, 20 insertions(+), 12 deletions(-)

This file doesn't build at this point in time, how did you build test
this?

I don't mind taking the patch, but please, don't lie.

thanks,

greg k-h
