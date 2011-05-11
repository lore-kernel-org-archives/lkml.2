Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1EKQeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:34:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab1EKQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:15:58 -0400
Date: Wed, 11 May 2011 11:35:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Felipe Wilhelms Damasio - Taghos <felipewd@taghos.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: XFS deadlock fixed?
Message-ID: <20110511153501.GA8457@infradead.org>
References: <4DC8B397.20207@taghos.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC8B397.20207@taghos.com.br>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:40:07AM -0300, Felipe Wilhelms Damasio - Taghos wrote:
>     Hi Mr. Hellwig,
> 
>     I saw the XFS deadlock thread regarding 2.6.38:
> 
> http://www.linux.sgi.com/archives/xfs/2011-03/msg00185.html
> 
>     I'm seeing too in 2.6.38.4. A lot of
> 
> XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)

You're probably running into a different issue.  Any chance you can try
the attached patch to see where you're stuck exactly?

Also in case you're using slub (CONFIG_SLUB) can you check if it still
happens when using slab (CONFIG_SLAB) instead?

