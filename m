Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1HBBS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:18:56 -0400
Received: from fieldses.org ([174.143.236.118]:60933 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab1HBBSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:18:53 -0400
Date: Mon, 1 Aug 2011 21:18:52 -0400
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Here's a unified kernel git repo covering 0.0.1 to the present.
Message-ID: <20110802011851.GC16305@fieldses.org>
References: <4E2A43F5.1020209@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2A43F5.1020209@landley.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 10:45:57PM -0500, Rob Landley wrote:
> Ever done a "git annotate" that stops at 2.6.12-rc2, and wanted to see 
> the full history?  Here's an repository that goes all the way back to
> 0.0.1 (through bitkeeper and all those old tarballs), which otherwise
> works as normal (git pull updates it from Linus's tree, you can commit
> to it and branch from it, etc)
> 
> Here's the tarball:
> 
>   http://www.kernel.org/pub/linux/kernel/people/landley/linux-fullhist.tar.bz2
> 
> To install it:
> 
>   1) Download, extract, cd into the directory.
>   2) git checkout -f
>   3) git pull

Note if you use git-replace instead of grafts then you should be able to
post it as a normal clone-able git tree.

--b.

> 
> Then use as normal.
> 
> This is based on the work of http://padator.org/linux.php with some
> trivial cleanups.
> 
> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
