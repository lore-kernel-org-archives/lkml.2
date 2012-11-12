Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2KLXI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:08:56 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55343 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2KLXIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:08:53 -0500
Date: Mon, 12 Nov 2012 15:09:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Tyler Hicks <tyhicks@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [ 3.5.yuz extended stable] Patch "eCryptfs: Unlink lower inode
 when ecryptfs_create() fails" has been added to staging queue
Message-ID: <20121112230915.GB4040@kroah.com>
References: <1352755737-16123-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352755737-16123-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 07:28:57PM -0200, Herton Ronaldo Krzesinski wrote:
> This is a note to let you know that I have just added a patch titled
> 
>     eCryptfs: Unlink lower inode when ecryptfs_create() fails
> 
> to the linux-3.5.y-queue branch of the 3.5.yuz extended stable tree 
> which can be found at:
> 
>  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.5.y-queue
> 
> If you, or anyone else, feels it should not be added to the 3.5
> Linux kernel, or for any feedback related to it, please reply to
> this email. For more information on extended stable, see
> https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

It's nice that you are doing this work, but please don't send these
types of messages to the stable@vger.kernel.org mailing list as they
aren't really relevant there at all.  I doubt that lkml also cares about
them either, I know I always strip off public mailing lists (except for
stable) when sending these types of messages.

Also, you might want to reword that last paragraph a bit...

thnaks,

greg k-h
