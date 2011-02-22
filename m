Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1BVXwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:52:51 -0500
Received: from kroah.org ([198.145.64.141]:33274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab1BVXwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:52:50 -0500
Date: Tue, 22 Feb 2011 15:51:33 -0800
From: Greg KH <greg@kroah.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 1/8] pch_uart: add multi-scatter processing
Message-ID: <20110222235133.GA31831@kroah.com>
References: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 11:23:57AM +0900, Tomoya MORINAGA wrote:
> Currently, this driver can handle only single scatterlist.
> Thus, it can't send data beyond FIFO size.
> 
> This patch enables this driver can handle multiple scatter list.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/serial/pch_uart.c |  117 ++++++++++++++++++++++++++++++++++-----------

What kernel tree did you make this against?  the pch_uart.c file is not
in this location anymore.

Care to redo this series against the linux-next tree so that I can apply
it properly?

thanks,

greg k-h
