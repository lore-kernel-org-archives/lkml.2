Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2BYQxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 11:53:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53958 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756589Ab2BYQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 11:53:03 -0500
X-Sasl-enc: RTwqrvUhro/06MxjRFdDiPkoQE6gtvF6K62DyKetu8En 1330188782
Date: Sat, 25 Feb 2012 08:52:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/usb: fix usb CTRL_PHY_CLK_VALID breaks on some
 platform
Message-ID: <20120225165219.GA21703@kroah.com>
References: <1330185390-30614-1-git-send-email-Shengzhou.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330185390-30614-1-git-send-email-Shengzhou.Liu@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 11:56:30PM +0800, Shengzhou Liu wrote:
> Fix checking of CTRL_PHY_CLK_VALID bit break on some platform on which
> there is not USB CTRL_PHY_CLK_VALID bit.
>   - P1023/P3041/P5020 etc,have this bit
>   - P3060/4080/PSC913x do have this bit, but not mentioned in RM.
>   - P1022(perhaps and other) has no this bit
> 
> Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
> ---
>  drivers/usb/host/ehci-fsl.c |   24 ++++++++++++++----------
>  1 files changed, 14 insertions(+), 10 deletions(-)

Is this something that needs to go into 3.3, or can it wait for 3.4?

thanks,

greg k-h
