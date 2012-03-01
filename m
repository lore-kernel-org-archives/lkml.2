Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab2CATgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:36:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52184 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2CATgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:36:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.224.230 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Thu, 1 Mar 2012 11:36:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Ott <alan@signal11.us>
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 8/8] ARM: tegra: HACK: remove set_irq_flags() from driver
Message-ID: <20120301193643.GA607@kroah.com>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
 <1330630010-11241-9-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330630010-11241-9-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 02:26:50PM -0500, Alan Ott wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver should not call set_irq_flags itself, and
> cannot do this from a loadable module.
> 
> Remove the call for now, which might break the driver
> but at least lets the kernel link again.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Um, I think you should test this out before submitting it anywhere :)

As it is, I can't accept it.

greg k-h
