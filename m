Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab2JYS44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:56:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62358 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082Ab2JYS4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:56:54 -0400
Date: Thu, 25 Oct 2012 11:56:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v5 1/4] genalloc: add a global pool list, allow to find
 pools by phys address
Message-ID: <20121025185650.GA13639@kroah.com>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
 <1350570453-24546-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350570453-24546-2-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 04:27:30PM +0200, Philipp Zabel wrote:
> This patch keeps all created pools in a global list and adds two
> functions that allow to retrieve the gen_pool pointer from a known
> physical address and from a device tree node.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  include/linux/genalloc.h |   14 ++++++++++
>  lib/genalloc.c           |   67 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 81 insertions(+)

I need some acks from the owners of this file (Paul and Andrew?) before
I can take this series.

thanks,

greg k-h
