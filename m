Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0K2O5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:57:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39447 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab0K2O5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:57:20 -0500
Date: Mon, 29 Nov 2010 09:57:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fs/fs-writeback.c: Fix sync_inodes_sb() return value
 kernel-doc
Message-ID: <20101129145718.GA26076@infradead.org>
References: <1290789310-2626-1-git-send-email-stefanha@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290789310-2626-1-git-send-email-stefanha@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 04:35:10PM +0000, Stefan Hajnoczi wrote:
> The sync_inodes_sb() function does not have a return value.  Remove the
> outdated documentation comment.

Looks good.

