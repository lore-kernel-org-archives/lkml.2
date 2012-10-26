Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888Ab2JZSND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:13:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:34241 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965748Ab2JZSNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:13:00 -0400
Date: Fri, 26 Oct 2012 11:12:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yan Hong <clouds.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] debugfs: code clean and refactor
Message-ID: <20121026181259.GC25530@kroah.com>
References: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
 <1351274144-31591-2-git-send-email-clouds.yan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351274144-31591-2-git-send-email-clouds.yan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 01:55:43AM +0800, Yan Hong wrote:
> debug_fill_super():
> 	return directly if failed to allocate debugfs_fs_info.
> 
> __create_file():
> 	remove redundant initialization.
> 
> __debugfs_remove():
> 	remove redundant check.
> 	debugfs_positive() already checked dentry->inode is not NULL.

You did 3 different things, so that should be at least 3 different
patches.

thanks,

greg k-h
