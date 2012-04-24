Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab2DXSfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:35:22 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:44347 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2DXSfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:35:21 -0400
Date: Tue, 24 Apr 2012 11:35:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        trivial@kernel.org, Xi Wang <xi.wang@gmail.com>,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 2/3] staging: vt6656: remove redundant parentheses from
 ioctl.c
Message-ID: <20120424183516.GA31247@kroah.com>
References: <alpine.LNX.2.00.1204212156260.25551@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1204212203030.25551@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204212203030.25551@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 10:04:37PM +0200, Jesper Juhl wrote:
> I seriously doubt that anyone is confused about the precedence rules
> for "*" and "+" - remove redundant extra parentheses.

You never really know, and as such, I'd prefer to just leave this as-is.

thanks,

greg k-h
