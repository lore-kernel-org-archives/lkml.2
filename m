Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab0KARln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:41:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab0KARll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:41:41 -0400
Date: Mon, 1 Nov 2010 13:41:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Bryan Schumaker <bjschuma@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] locks: fix leaks on setlease errors
Message-ID: <20101101174122.GA12604@infradead.org>
References: <20101030212500.GE480@fieldses.org>
 <1288474276-14288-2-git-send-email-bfields@redhat.com>
 <20101031111057.GA23760@infradead.org>
 <20101101172440.GC2340@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101172440.GC2340@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 01:24:40PM -0400, J. Bruce Fields wrote:
> I also have patches that get rid of fl_release_private, fl_mylease, and
> (almost done) fl_change.
> 
> Unless you've a better suggestion I'll probably send them out for review
> and then queue them up with other nfsd changes for 2.6.38.

Sounds good.  I was also wondering if we can get rid of ->setlease
entirely.  The file_lock_operations should be enough abstraction to
reject the leases in theory, but I need to look into it a bit more.

