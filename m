Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab1ETNBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:01:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab1ETNBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:01:30 -0400
Date: Fri, 20 May 2011 09:01:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.39 merge window
Message-ID: <20110520130127.GA3428@infradead.org>
References: <1305888118.2571.5.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305888118.2571.5.camel@mulgrave.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 02:41:58PM +0400, James Bottomley wrote:
> new fc module for the in-kernel target infrastructure and final removal
> of the SCSI serial number, which served only to bounce lock cache lines
> in the critical path.

It's actually not completely gone yet, but we're one step closer now.

