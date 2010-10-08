Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab0JHNnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:43:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab0JHNnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:43:19 -0400
Date: Fri, 8 Oct 2010 09:43:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101008134315.GA14807@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-12-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 1162c10..34f983f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -383,6 +383,7 @@ struct inodes_stat_t {
>  #include <linux/capability.h>
>  #include <linux/semaphore.h>
>  #include <linux/fiemap.h>
> +#include <linux/rculist_bl.h>

rculist_bl.h doesn't actually exist anymore in your tree, so this needs
to be list_bl.h to actually compile.

