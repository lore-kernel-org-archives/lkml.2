Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1DRJ2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:28:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1DRJ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:28:04 -0400
Date: Mon, 18 Apr 2011 05:28:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        sliakh.lkml@gmail.com, jiang@cs.ncsu.edu, rusty@rustcorp.com.au,
        mingo@elte.hu
Subject: Re: Undoing module RONX protection
Message-ID: <20110418092801.GC3837@infradead.org>
References: <20110418092348.GB7786@hal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418092348.GB7786@hal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int set_memory_x(unsigned long addr, int numpages)
> +{
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(set_memory_x);

No need to export this one.

