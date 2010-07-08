Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0GHUEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:04:14 -0400
Received: from kroah.org ([198.145.64.141]:34426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab0GHUEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:04:10 -0400
Date: Thu, 8 Jul 2010 12:59:02 -0700
From: Greg KH <greg@kroah.com>
To: Joe Eloff <kagen101@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Staging: dt3155: fix coding style issues in
 dt3155_drv.c
Message-ID: <20100708195902.GA3530@kroah.com>
References: <1278350030.5396.25.camel@dermezel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278350030.5396.25.camel@dermezel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 07:13:50PM +0200, Joe Eloff wrote:
> >From a19d065175340cdf0b93e3b23c134b887678fdf4 Mon Sep 17 00:00:00 2001
> From: Joe Eloff <kagen101@gmail.com>
> Date: Mon, 5 Jul 2010 18:55:08 +0200
> Subject: [PATCH] Staging: dt3155: fix coding style issues in dt3155_drv.c
> 
> This is a patch to the dt3155_drv.c file that fixes up most warnings and errors found by the checkpatch.pl tool.
>     * Errors:   93 -> 10
>     * Warnings: 103-> 14
> Signed-off-by: Joe Eloff <kagen101@gmail.com>

This doesn't apply to the latest linux-next tree, care to redo it?

thanks,

greg k-h
