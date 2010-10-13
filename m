Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab0JMCJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 22:09:08 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:44073 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751637Ab0JMCJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 22:09:06 -0400
Date: Wed, 13 Oct 2010 13:09:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: icache remove inode_lock
Message-ID: <20101013020902.GU4681@dastard>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-16-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:15:58AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All the functionality that the inode_lock protected has now been
> wrapped up in new independent locks and/or functionality. Hence the
> inode_lock does not serve a purpose any longer and hence can now be
> removed.
> 
> Based on work originally done by Nick Piggin.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  Documentation/filesystems/Locking |    2 +-
>  Documentation/filesystems/porting |   10 +++-
>  Documentation/filesystems/vfs.txt |    2 +-

I forgot to update these files again. I will send another version of
this patch when I've done it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
