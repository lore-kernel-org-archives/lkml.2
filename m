Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab1GWBqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 21:46:44 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47106
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820Ab1GWBqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 21:46:38 -0400
Date: Fri, 22 Jul 2011 21:46:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: jaxboe@fusionio.com, Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] block: strict rq_affinity
Message-ID: <20110723014633.GA32507@infradead.org>
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6>
 <20110722205938.17420.68621.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722205938.17420.68621.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 01:59:39PM -0700, Dan Williams wrote:
> Some storage controllers benefit from completions always being steered
> to the strict requester cpu rather than the looser "per-socket" steering
> that blk_cpu_to_group() attempts by default.

Isn't this actually dependent on the cpu, and not the storage
controller?

