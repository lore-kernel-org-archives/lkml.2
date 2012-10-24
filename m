Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab2JXV1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:27:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35499 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2JXV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:27:36 -0400
Date: Wed, 24 Oct 2012 14:27:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: nsekhar@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6] Enable USB peripheral mode on dm365 EVM
Message-ID: <20121024212732.GA31406@kroah.com>
References: <1349872412-22040-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349872412-22040-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 02:33:32PM +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Sets USB PHY clock source to 24 MHz clock and call USB configuration from board initialization.
> 
> Tested with OTG configuration, usb gadget g_zero on DM365 EVM connected to PC.
> 
> References:
> 
> Definition of USB_PHY_CTRL and PHYCLKFREQ:
> - http://www.makelinux.com/lib/ti/DM36x_ARM/doc-141
> 
> Original patch by miguel.aguilar@ridgerun.com three years ago:
> - http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg14741.html
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>

Note, Felipe is the right person to be sending these types of patches
to, not me.  scripts/get_maintainer.pl is your friend :)

thanks,

greg k-h
