Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2AYAGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:06:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34834 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317Ab2AYAGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:06:47 -0500
X-Sasl-enc: FPZX3Y62V22EgVdxNPBemZWXRPE6Js3DDwzZ97bHOiz7 1327450006
Date: Tue, 24 Jan 2012 15:55:51 -0800
From: Greg KH <greg@kroah.com>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] debugfs: add mode, uid and gid options
Message-ID: <20120124235551.GA24596@kroah.com>
References: <1326729981-6605-1-git-send-email-ludwig.nussel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326729981-6605-1-git-send-email-ludwig.nussel@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 05:06:21PM +0100, Ludwig Nussel wrote:
> Cautious admins may want to restrict access to debugfs. Currently a
> manual chown/chmod e.g. in an init script is needed to achieve that.
> Distributions that want to make the mount options configurable need
> to add extra config files. By allowing to set the root inode's uid,
> gid and mode via mount options no such hacks are needed anymore.
> Instead configuration becomes straight forward via fstab.
> 
> Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>

I've applied this now, but shouldn't it also be documented somewhere as
well?  Please send a follow-on patch doing that.

thanks,

greg k-h
