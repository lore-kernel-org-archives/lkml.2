Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1DRMkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:40:47 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:59150 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1DRMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:40:43 -0400
Date: Mon, 18 Apr 2011 14:40:37 +0200
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        sliakh.lkml@gmail.com, jiang@cs.ncsu.edu, rusty@rustcorp.com.au,
        mingo@elte.hu
Subject: Re: Undoing module RONX protection
Message-ID: <20110418124037.GC7786@hal>
References: <20110418092348.GB7786@hal>
 <20110418092801.GC3837@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418092801.GC3837@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 05:28:01AM -0400, Christoph Hellwig wrote:
> > +int set_memory_x(unsigned long addr, int numpages)
> > +{
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(set_memory_x);
> 
> No need to export this one.

True. Also for the other exports in that file. Will remove them.

--Jan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
