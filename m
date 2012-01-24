Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2AYAGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:06:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52687 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585Ab2AYAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:06:49 -0500
X-Sasl-enc: zIv4KECXc7Qs6WkWnUTmPqRSFNZwQ+1MKkSJ5Y9RZRuK 1327450008
Date: Tue, 24 Jan 2012 15:57:34 -0800
From: Greg KH <greg@kroah.com>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] debugfs: add mode, uid and gid options
Message-ID: <20120124235734.GA28585@kroah.com>
References: <1326729981-6605-1-git-send-email-ludwig.nussel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Oops, no, I didn't apply this as I get a compiler warning with it
applied:

fs/debugfs/inode.c:244:2: warning: initialization from incompatible pointer type [enabled by default]
fs/debugfs/inode.c:244:2: warning: (near initialization for ‘debugfs_super_operations.show_options’) [enabled by default]

Please fix this and resend.

thanks,

greg k-h
