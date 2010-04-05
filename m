Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0DEUAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:00:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab0DEUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:00:04 -0400
Date: Mon, 5 Apr 2010 16:00:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org,
       mkp@mkp.net
Subject: Re: [PATCH 4/5] blkdev: add discard payload flag
Message-ID: <20100405200003.GB17589@infradead.org>
References: <1269451988-5270-1-git-send-email-dmonakhov@openvz.org> <1269451988-5270-2-git-send-email-dmonakhov@openvz.org> <1269451988-5270-3-git-send-email-dmonakhov@openvz.org> <1269451988-5270-4-git-send-email-dmonakhov@openvz.org> <1269451988-5270-5-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269451988-5270-5-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 08:33:07PM +0300, Dmitry Monakhov wrote:
> Not all implementations require discard bio to be filled with one-sector
> sized payload. Let's allocate payload only when necessary.

Neither this nor the next one are really needed as I have some patches
pending to move the payload allocation into the low level drivers.

