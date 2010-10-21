Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab0JUCRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:17:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab0JUCRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:17:23 -0400
Date: Wed, 20 Oct 2010 22:17:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/21] fs: protect wake_up_inode with inode->i_lock
Message-ID: <20101021021722.GB5241@infradead.org>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287622186-1935-18-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, and thanks for documenting unlock_new_inode.


Reviewed-by: Christoph Hellwig <hch@lst.de>

