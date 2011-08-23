Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab1HWSuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:50:52 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54564 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474Ab1HWSup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:50:45 -0400
X-Sasl-enc: QoqsWWJH61NJKvbzN2UqZkO5qYRM2YwJrEgJCMaeR2Mw 1314125444
Date: Tue, 23 Aug 2011 11:50:20 -0700
From: Greg KH <greg@kroah.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: Re: [PATCH 5/5] staging: et131x: Fix free IRQ from IRQ context
 warning after tx_timeout
Message-ID: <20110823185020.GA11302@kroah.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 10:47:01PM +0100, Mark Einon wrote:
> When a tx timeout occured, et131x_tx_timeout closed and re-opened the device to fix.
> As et131x_close called free_irq(), bad things ensued (see warning trace below), namely a
> storm of errors and warnings.
> Fixed by replacing the close() and open() calls with just the relevant functions previously
> called from these.
> Verified on an ET-1310 device.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>

This patch breaks the build :(

Care to resend this one, and any other patch you have sent me but I
didn't apply yet, again, as I have now applied all et131x patches in my
queue.

thanks,

greg k-h
