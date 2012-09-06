Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106Ab2IFQZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:25:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50803 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab2IFQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:25:53 -0400
Date: Thu, 6 Sep 2012 09:23:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Hlavacek <tmshlvck@gmail.com>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, marek.vasut@gmail.com
Subject: Re: [PATCH v6] tty: uartclk value from serial_core exposed to sysfs
Message-ID: <20120906162317.GA25171@kroah.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
 <1346894238-12870-1-git-send-email-tmshlvck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346894238-12870-1-git-send-email-tmshlvck@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:17:18AM +0200, Tomas Hlavacek wrote:
> Added file /sys/devices/.../tty/ttySX/uartclk to allow reading
> uartclk value in struct uart_port in serial_core via sysfs.
> 
> tty_register_device() has been generalized and refactored in order
> to add support for setting drvdata and attribute_group to the device.
> 
> Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>

Thanks, that worked, I've now applied this.

greg k-h
