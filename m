Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab2EBULC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:11:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab2EBULA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:11:00 -0400
Date: Wed, 2 May 2012 13:10:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sysfs: Removed dup_name entirely in sysfs_rename
Message-ID: <20120502201055.GA26148@kroah.com>
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

What kernel version did you create this against?  There is some odd fuzz
and offsets aren't right here, you should at the least, make it against
Linus's latest tree, and ideally against linux-next, this one was made
against neither, so I can't really apply it.

Care to refresh it against Linus's tree and resend it so I can apply it?

It makes me wonder how you tested it...

greg k-h
