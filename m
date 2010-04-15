Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0DORAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:00:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0DORAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:00:07 -0400
Date: Thu, 15 Apr 2010 13:00:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Fix compat uname machine
Message-ID: <20100415170006.GA25874@infradead.org>
References: <m2wrw8he8e.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2wrw8he8e.fsf@igel.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:28:33PM +0200, Andreas Schwab wrote:
> Mask off personality flags when checking for PER_LINUX32.
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
> On ppc64 you get this error:
> 
> $ setarch ppc -R true
> setarch: ppc: Unrecognized architecture
> 
> because uname still reports ppc64 as the machine.


Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
