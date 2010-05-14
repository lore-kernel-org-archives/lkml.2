Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab0ENK3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:29:22 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:47894 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab0ENK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:29:19 -0400
Date: Fri, 14 May 2010 09:57:42 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: drop the "state" argument to mmc_suspend_host()
Message-ID: <20100514075742.GA21531@prithivi.gnumonks.org>
References: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:01:45PM +0100, Matt Fleming wrote:
> Even though many mmc host drivers pass a pm_message_t argument to
> mmc_suspend_host() that argument isn't used the by MMC core. As host
> drivers are converted to dev_pm_ops they'll have to construct
> pm_message_t's (as they won't be passed by the PM subsystem any more)
> just to appease the mmc suspend interface.
> 
> We might as well just delete the unused paramter.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

for via-sdmmc:

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
