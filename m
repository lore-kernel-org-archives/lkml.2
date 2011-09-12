Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab1ILP2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:28:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53353
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757929Ab1ILP2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:28:12 -0400
Date: Mon, 12 Sep 2011 11:28:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pavel Ivanov <paivanof@gmail.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH] hfsplus: Fix kfree of wrong vhdr pointers
Message-ID: <20110912152811.GA9437@infradead.org>
References: <CAG1a4rubbzvOE3KoGmc_9svS-UFX8gzuE=3TnVYfGAeXCJpLYw@mail.gmail.com>
 <1315841227-24535-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315841227-24535-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 10:27:07AM -0500, Seth Forshee wrote:
> Commit 6596528 (hfsplus: ensure bio requests are not smaller than
> the hardware sectors) changed the pointers used for volume header
> allocations, but a couple of spots are still freeing the old
> pointers. This patch fixes the problem.

I've already respun the patch to include your Pavel's additional
fixes.  Just waiting to sort out the size checking issue, and then
I will send both things on to Linus.

