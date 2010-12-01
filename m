Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0LAB2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:28:36 -0500
Received: from kroah.org ([198.145.64.141]:51184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab0LAB2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:28:35 -0500
Date: Tue, 30 Nov 2010 17:24:41 -0800
From: Greg KH <greg@kroah.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Mike Frysinger <vapier@gentoo.org>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        yong.y.wang@intel.com, qi.wang@intel.com, kok.howg.ewe@intel.com,
        andrew.chih.howe.khor@intel.com
Subject: Re: Serial: EG20T: add PCH_UART driver
Message-ID: <20101201012441.GA2907@kroah.com>
References: <4CE3281A.4050709@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CE3281A.4050709@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 09:55:54AM +0900, Tomoya MORINAGA wrote:
> UART driver of Intel EG20T(Topcliff) PCH
> 
> Intel EG20T PCH is the platform controller hub that is going to be used in
> Intel's general embedded platform. All IO peripherals in
> Intel EG20T PCH are actually devices sitting on AMBA bus. 
> Intel EG20T PCH has UART I/F. Using this I/F, it is able to access system
> devices connected to UART.

I've applied this, but I now get the following warnings when building
the code:
drivers/serial/pch_uart.c: In function ‘dma_handle_rx’:
drivers/serial/pch_uart.c:685:24: warning: cast from pointer to integer of different size
drivers/serial/pch_uart.c: In function ‘dma_handle_tx’:
drivers/serial/pch_uart.c:778:23: warning: cast from pointer to integer of different size
drivers/serial/pch_uart.c: In function ‘pch_uart_init_port’:
drivers/serial/pch_uart.c:1289:20: warning: cast to pointer from integer of different size
drivers/serial/pch_uart.c: In function ‘pch_uart_exit_port’:
drivers/serial/pch_uart.c:1328:2: warning: cast from pointer to integer of different size

Please send me a follow-up patch to resolve this.

thanks,

greg k-h
