Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1GFDit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:38:49 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50307 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab1GFDir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:38:47 -0400
X-Sasl-enc: UJjSXySraktr0me7sn+EmKWxl9COHqbbjFopepB7IERC 1309923526
Date: Tue, 5 Jul 2011 20:36:30 -0700
From: Greg KH <greg@kroah.com>
To: Chris Forbes <chrisf@ijw.co.nz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: iio: adc: fix uninitialized use
Message-ID: <20110706033630.GA29391@kroah.com>
References: <1309657621-21711-1-git-send-email-chrisf@ijw.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309657621-21711-1-git-send-email-chrisf@ijw.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 01:47:01PM +1200, Chris Forbes wrote:
> Fixed an uninitialized variable access. In the first two error paths in
> max1363_probe(), 'st' is not yet initialized, but its 'reg' member is
> accessed anyway. This would most likely crash.
> 
> The intended value for st->reg *is* available at that point in 'reg',
> so just use that directly.

This doesn't apply anymore, care to redo it against the latest
staging-next branch and resend?

thanks,

greg k-h
