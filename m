Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab0JMPIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:08:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48305 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab0JMPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:08:18 -0400
Date: Wed, 13 Oct 2010 11:08:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: split __inode_add_to_list
Message-ID: <20101013150817.GB12757@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-18-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  	if (!list_empty(&inode->i_sb_list)) {
> -		spin_lock(&inode->i_sb->s_inodes_lock);
> -		list_del_init(&inode->i_sb_list);
> -		spin_unlock(&inode->i_sb->s_inodes_lock);
> +		inode_sb_list_del(inode);
>  	}

no need to keep the braces here.

