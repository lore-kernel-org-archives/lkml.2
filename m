Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab2LCSIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:08:36 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47568 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2LCSId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:08:33 -0500
Date: Mon, 3 Dec 2012 10:08:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: yangsheng <sickamd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, adilger@dilger.ca
Subject: Re: [PATCH] Update atime from future.
Message-ID: <20121203180828.GA30435@kroah.com>
References: <1354557399-6202-1-git-send-email-sickamd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354557399-6202-1-git-send-email-sickamd@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 01:56:39AM +0800, yangsheng wrote:
> Relatime should update the inode atime if it is more than a day in the
> future.  The original problem seen was a tarball that had a bad atime,
> but could also happen if someone fat-fingers a "touch".  The future
> atime will never be fixed.  Before the relatime patch, the future atime
> would be updated back to the current time on the next access.
> 
> Only update the atime if it is more than one day in the future.  That
> avoids thrashing the atime if the clocks on clients of a network fs are
> only slightly out of sync, but still allows fixing bogus atimes.
> 
> Signed-off-by: yangsheng <sickamd@gmail.com>
> Reviewed-by: adilger@dilger.ca
> ---
>  fs/inode.c | 10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
