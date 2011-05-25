Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab1EYIET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:04:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab1EYIEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:04:13 -0400
Date: Wed, 25 May 2011 04:04:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
Message-ID: <20110525080409.GA16582@infradead.org>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 04:53:50PM -0700, David Rientjes wrote:
> The Cisco FNIC driver requires creating a SLAB_CACHE_DMA cache, which is
> not possible if CONFIG_ZONE_DMA is disasbled.  Avoid compiling it without
> DMA support.

And you're sure it actually needs it and isn't some sort of typo?  It
might help to Cc the maintainer to figure that out.

