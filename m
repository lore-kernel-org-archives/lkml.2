Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0I2XRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 19:17:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0I2XRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 19:17:46 -0400
Date: Wed, 29 Sep 2010 19:17:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: smfrench@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] cifs: set backing_dev_info on new S_ISREG inodes
Message-ID: <20100929231730.GA6921@infradead.org>
References: <1285768194-29595-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285768194-29595-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:49:54AM -0400, Jeff Layton wrote:
> Testing on very recent kernel (2.6.36-rc6) made this warning pop:
> 
>     WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x65/0x70()
>     Hardware name:
>     Dirtiable inode bdi default != sb bdi cifs
> 
> ...the following patch fixes it and seems to be the obviously correct
> thing to do for cifs.

See my patch in the btrfs/default_backing_dev_info thread for the real
fix for the underlying issue.  But your patch won't harm either way.

