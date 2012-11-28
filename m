Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2K1QKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:10:22 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60361
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187Ab2K1QKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:10:20 -0500
Date: Wed, 28 Nov 2012 11:10:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 06/19] list: add a new LRU list type
Message-ID: <20121128161018.GA15089@infradead.org>
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
 <1354058086-27937-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354058086-27937-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:14:33AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Several subsystems use the same construct for LRU lists - a list
> head, a spin lock and and item count. They also use exactly the same
> code for adding and removing items from the LRU. Create a generic
> type for these LRU lists.
> 
> This is the beginning of generic, node aware LRUs for shrinkers to
> work with.

Can you please add kerneldoc comments for the functions, and add
symbolic constants for the possible return values from the isolate
callback?

