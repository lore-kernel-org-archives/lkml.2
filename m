Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1LLWma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:42:30 -0500
Received: from verein.lst.de ([213.95.11.211]:47654 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab1LLWm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:42:29 -0500
Date: Mon, 12 Dec 2011 23:42:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Xi Wang <xi.wang@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix acl count validation in xfs_acl_from_disk()
Message-ID: <20111212224227.GA17461@lst.de>
References: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 04:55:52PM -0500, Xi Wang wrote:
> Commit fa8b18ed didn't prevent the integer overflow and possible
> memory corruption.  "count" can go negative and bypass the check.

Thanks, this looks good to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>
