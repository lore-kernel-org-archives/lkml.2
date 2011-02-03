Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1BCP5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:57:02 -0500
Received: from cantor.suse.de ([195.135.220.2]:46177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab1BCP5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:57:01 -0500
Date: Thu, 3 Feb 2011 07:56:12 -0800
From: Greg KH <gregkh@suse.de>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Correctly check d_alloc_name() return code in
 devpts_pty_new
Message-ID: <20110203155612.GA983@suse.de>
References: <1296732551-10235-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296732551-10235-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 02:29:11PM +0300, Andrey Vagin wrote:
> d_alloc_name return NULL in case error, but we expect errno in
> devpts_pty_new.
> 
> http://bugzilla.openvz.org/show_bug.cgi?id=1758
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  fs/devpts/inode.c |    2 +-

Nice, but I'm not the devpts maintainer, why not send this to the vfs
maintainer instead?

thanks,

greg k-h
