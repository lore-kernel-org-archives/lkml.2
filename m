Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0GGBwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:52:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab0GGBwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:52:08 -0400
Date: Tue, 6 Jul 2010 21:52:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/6] block: push down BKL into .locked_ioctl
Message-ID: <20100707015207.GE2950@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278193640-24223-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at this again I don't like the foo_unlock_ioctl naming you're
adding.  Just rename the existing ioctl routines to foo_locked_ioctl
or move the lock_kernel/unlock_kernel calls into the function, which
would be even better.

