Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0FDH4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:56:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:44836 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab0FDH4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:56:18 -0400
Date: Fri, 4 Jun 2010 17:56:14 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
 scanning to current EOF
Message-ID: <20100604075614.GB26335@laptop>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
 <1275609328-12514-7-git-send-email-david@fromorbit.com>
 <20100604075223.GB7317@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604075223.GB7317@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 03:52:23AM -0400, Christoph Hellwig wrote:
> Even if there still are potential livelocks after this it's a big
> step in the right direction, so
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Agreed.
