Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab2KZWu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:50:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:37503 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab2KZWu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:50:58 -0500
Date: Mon, 26 Nov 2012 14:50:56 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: new warnings from partial __devexit removal
Message-ID: <20121126225056.GB28995@kroah.com>
References: <201211262038.32276.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211262038.32276.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 08:38:32PM +0000, Arnd Bergmann wrote:
> This is probably known and fixed already, but in case it's not, let me just
> mention that I saw two new warnings with ARM allyesconfig about a
> __devexit being removed but the __devexit_p() still being there:
> 
> drivers/tty/serial/xilinx_uartps.c:1000:12: error: 'xuartps_remove' defined but not used [-Werror=unused-function]
> drivers/usb/gadget/mv_udc_core.c:2131:12: error: 'mv_udc_remove' defined but not used [-Werror=unused-function]

What platform has -Werror=unused-function set?

Bill, care to send follow-on patches to resolve these warnings?

thanks,

greg k-h
