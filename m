Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0FKQgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:36:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50609 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0FKQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:36:49 -0400
Date: Fri, 11 Jun 2010 18:36:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100611163644.GH6864@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org> <20100610111052.3DDC5B1A2B@basil.firstfloor.org> <20100611162007.GC7556@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611162007.GC7556@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:20:07PM -0400, Christoph Hellwig wrote:
> Most of this looks good to me, but I really don't like the QASSERT
> macro.  If you're fine with it I'll split this up into smaller patches

Why do you not like it? 

The alternative will be likely uglier.

> and resubmit the unmodified parts under your name and redo those bits
> I don't like.

Fine for me.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
