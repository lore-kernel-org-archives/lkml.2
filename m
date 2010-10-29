Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab0J2JoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:44:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab0J2JoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:44:02 -0400
Date: Fri, 29 Oct 2010 05:43:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] fs: move i_wb_list out from under inode_lock
Message-ID: <20101029094358.GA9052@infradead.org>
References: <1288342803-14957-1-git-send-email-david@fromorbit.com>
 <1288342803-14957-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288342803-14957-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -extern int evict_inodes(struct super_block *);
> +extern void evict_inodes(struct super_block *);

err, evict_inodes doesn't change in this patch.

