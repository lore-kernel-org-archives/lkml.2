Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab2KPMhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:37:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:45308 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2KPMhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:37:45 -0500
Date: Fri, 16 Nov 2012 04:38:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jun Chen <jun.d.chen@intel.com>
Cc: Alan Cox <alan@linux.intel.com>, Bi Chao <chao.bi@intel.com>,
        serial <linux-serial@vger.kernel.org>,
        "russ.gorby" <russ.gorby@intel.com>, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: [PATCH] serial: ifx6x60: ifx_spi_write don't need to do
 mrdy_assert when fifo is not empty.
Message-ID: <20121116123834.GA9327@kroah.com>
References: <1353064117.24092.4.camel@chenjun-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353064117.24092.4.camel@chenjun-workstation>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:08:37AM -0500, Jun Chen wrote:
> 
> This patch check whether the fifo lenth is empty before writing new data to fifo.If condition
> is true,ifx_spi_write need to trigger one mrdy_assert. If condition is false,the mrdy_assert
> will be trigger by the next ifx_spi_io.
> 
> Cc: Bi Chao <chao.bi@intel.com>
> Signed-off-by: Chen Jun <jun.d.chen@intel.com>
> ---
>  drivers/tty/serial/ifx6x60.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)

What tree did you make this against?  It doesn't apply to my tty-next
tree at all :(

greg k-h
