Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965824Ab2B1Qyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:54:41 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43732 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab2B1Qyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:54:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.230.201 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Tue, 28 Feb 2012 08:53:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Autif Khan <autifk@gmail.com>
Cc: rusty@rustcorp.com.au, jhovold@gmail.com, stern@rowland.harvard.edu,
        mchehab@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: usb: serial: sierra - upgrade to 1.7.40
Message-ID: <20120228165322.GB11133@kroah.com>
References: <1330447152-5770-1-git-send-email-autifk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330447152-5770-1-git-send-email-autifk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:39:12AM -0500, Autif Khan wrote:
> driver was upgraded from 1.7.16 to 1.7.40
> source of the driver at the time of this change:
> http://www.sierrawireless.com/resources/support/drivers/linux/v3.2_1740_kernel-3.0.directIP.tar
> 
> The driver compiles (monolithic and module)
> I have not tested it on any device

I need reasons for this update.  What changed, and why is what we need
to know.  No "wholesale" upgrade of a file is allowed, you need to break
the changes up into logical pieces, and send them with a proper
description of what happened here.

Also, please cc: and properly credit the original authors of these
changes, and the maintainer of the driver, to give them a chance to
review it.

So, sorry, I can't take these 3 patches unless they are broken up
properly, and I would like to get an ack from the driver
maintainer/author.

thanks,

greg k-h
