Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1LLWby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:31:54 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45377 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219Ab1LLWbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:31:53 -0500
X-Sasl-enc: jcbIFV4qC4vdOaODRDclyq7G+p0TdXUydDPkNVh6H3mN 1323729112
Date: Mon, 12 Dec 2011 14:19:55 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs
 files v2
Message-ID: <20111212221955.GA2268@kroah.com>
References: <1322856167-23030-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322856167-23030-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 12:02:46PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Allow passing path names to debugfs_create* and automatically create
> the parents. This makes it much simpler for the caller to create hierarchies.
> 
> The way the reference counts are handled is admittedly a bit ugly.
> 
> There is no way to clean them up currently other than to delete the tree,
> but that doesn't seem like a big problem for debugfs to leave
> behind a few empty directories.
> 
> v2: Comment fixes based on review comments.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

git, and checkpatch.pl complain a lot about this patch, care to fix up
the issues and resend it?

thanks,

greg k-h
