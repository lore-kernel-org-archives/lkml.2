Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2D3Nvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:51:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47018 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2D3Nva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:51:30 -0400
Date: Mon, 30 Apr 2012 09:51:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sysfs: Removed dup_name entirely in sysfs_rename
Message-ID: <20120430135123.GA14330@kroah.com>
References: <1335779216-32068-1-git-send-email-sasikanth.v19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335779216-32068-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 03:16:56PM +0530, Sasikantha babu wrote:
> Since no one using "dup_name", removed it completely in sysfs_rename, 
> 
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
> ---
>  fs/sysfs/dir.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)

Have you tested this patch and renamed some sysfs files with it with
SLAB_DEBUGGING enabled?  There was some "odd" things with regards to
names that I would like to ensure that is all still working properly
with this patch.

thanks,

greg k-h
