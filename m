Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0EaIrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:47:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab0EaIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:47:12 -0400
Date: Mon, 31 May 2010 04:47:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] mmc: add an ioctl for erasing
Message-ID: <20100531084709.GA7784@infradead.org>
References: <4BF68EFC.70101@nokia.com> <20100521140714.GB15070@infradead.org> <4C037731.5030301@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C037731.5030301@nokia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 11:45:37AM +0300, Adrian Hunter wrote:
> Sorry for the slow reply, I have been away.
>
> Connecting erase to discard was rejected for performance reasons in 2008.
> Refer:
>
> 	http://thread.gmane.org/gmane.linux.file-systems/25378/focus=25606

The discard implementation changed a lot since those days.  Discard
requests now have their own request size limitation which is separate
form that for normal requests, and we also store the alignment
requirement for them separately.

