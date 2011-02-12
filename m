Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab1BLQEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 11:04:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1BLQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 11:04:10 -0500
Date: Sat, 12 Feb 2011 08:04:04 -0800
From: Greg KH <gregkh@suse.de>
To: yenchengwang <yenchengwang@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_mass_storage: fixed a macro coding
 style issue
Message-ID: <20110212160404.GD26211@suse.de>
References: <1297438592-8566-1-git-send-email-yenchengwang@gmail.com>
 <20110211173918.GA9176@suse.de>
 <20110211185710.GB31385@core.coreip.homeip.net>
 <20110211191340.GA11733@suse.de>
 <AANLkTim_ZiR_GuD3e6KixxtX+r9z0+y2D66VJBRpp1ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim_ZiR_GuD3e6KixxtX+r9z0+y2D66VJBRpp1ab@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 04:15:21PM +0800, yenchengwang wrote:
> ah, I think I made a mistake...
> I watched this video
> http://archive.fosdem.org/2010/schedule/events/linuxkernelpatch,
> then tried the ./scripts/checkpatch.pl and see two ERROR:...
> so ... sent this patch, I apologize for my mistake, :(

That's great to do that, but you forgot the part of that talk that
showed you had to build your patch to verify that you did not break
anything.  Please do that in the future.

thanks,

greg k-h
