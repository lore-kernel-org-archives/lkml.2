Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0FKQUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:20:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab0FKQUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:20:13 -0400
Date: Fri, 11 Jun 2010 12:20:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
 statement warnings
Message-ID: <20100611162007.GC7556@infradead.org>
References: <20100610110.764742110@firstfloor.org>
 <20100610111052.3DDC5B1A2B@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610111052.3DDC5B1A2B@basil.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of this looks good to me, but I really don't like the QASSERT
macro.  If you're fine with it I'll split this up into smaller patches
and resubmit the unmodified parts under your name and redo those bits
I don't like.

