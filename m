Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2AYAeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:34:01 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55707 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064Ab2AYAd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:33:59 -0500
X-Sasl-enc: fX8iOyNeLE1G3YVry6WUj/XMTOxMDtTk22C6q7++2QPr 1327451638
Date: Tue, 24 Jan 2012 16:33:55 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: linux-next: build warning after merge of the usb.current tree
Message-ID: <20120125003355.GA18976@kroah.com>
References: <20120125112023.9cd8b4b1eedd717960e4c0a0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125112023.9cd8b4b1eedd717960e4c0a0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:20:23AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb.current tree, today's linux-next build (x86_64_allmodconfig)
> produced this warning:
> 
> drivers/usb/host/Kconfig:559:error: recursive dependency detected!
> drivers/usb/host/Kconfig:559:	symbol USB_HWA_HCD depends on UWB
> drivers/uwb/Kconfig:5:	symbol UWB is selected by USB_WUSB
> drivers/usb/wusbcore/Kconfig:4:	symbol USB_WUSB is selected by USB_HWA_HCD
> 
> Introduced by commit 0dd2b62ada6f ("drivers: usb: Fix dependency for
> USB_HWA_HCD").

Yeah, I just reverted that about 30 minutes, you must have pulled before
I pushed that change out.

thanks,

greg k-h
