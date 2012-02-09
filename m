Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab2BIRUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:20:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60422 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157Ab2BIRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:20:49 -0500
Date: Thu, 9 Feb 2012 09:12:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Remove configuration parameter
 CONFIG_R8712_AP
Message-ID: <20120209171247.GA31663@kroah.com>
References: <4f2da2e6.fVTqWGXhdTGpLskE%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f2da2e6.fVTqWGXhdTGpLskE%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 03:28:06PM -0600, Larry Finger wrote:
> The configuration parameter R8712_AP is misleading as the driver cannot
> function as an AP without a heavily hacked version of hostapd. Thus, it
> makes sense to remove the parameter; however the code and data configured
> for the option is left in.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

This doesn't apply for some odd reason:

patching file drivers/staging/rtl8712/Kconfig
patching file drivers/staging/rtl8712/rtl871x_sta_mgt.c
Hunk #1 FAILED at 42.
Hunk #2 succeeded at 71 (offset -1 lines).
1 out of 2 hunks FAILED -- saving rejects to file drivers/staging/rtl8712/rtl871x_sta_mgt.c.rej
patching file drivers/staging/rtl8712/sta_info.h

I did this against my staging-next branch, can you redo it and resend
it?

thanks,

greg k-h
