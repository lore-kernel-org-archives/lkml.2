Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1GKJ5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:57:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54006
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1GKJ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:57:11 -0400
Date: Mon, 11 Jul 2011 05:57:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/14] vmscan: add shrink_slab tracepoints
Message-ID: <20110711095708.GB19354@infradead.org>
References: <1310098486-6453-1-git-send-email-david@fromorbit.com>
 <1310098486-6453-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310098486-6453-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 02:14:34PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> ??t is impossible to understand what the shrinkers are actually doing
> without instrumenting the code, so add a some tracepoints to allow
> insight to be gained.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.  But wouldn't it be a good idea to give the shrinkers names
so that we can pretty print those in the trace event?

