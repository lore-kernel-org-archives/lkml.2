Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0DVK6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:58:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:45744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab0DVK6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:58:18 -0400
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
From: David Woodhouse <dwmw2@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20100422103953.GB27497@kernel.dk>
References: <20100417184016.GA17345@logfs.org>
	 <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org>
	 <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org>
	 <20100422090303.GA27497@kernel.dk>  <20100422103953.GB27497@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 11:58:11 +0100
Message-ID: <1271933891.11751.1508.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 12:39 +0200, Jens Axboe wrote:
> 
> Here's a series for fixing these. At this point they are totally
> untested except that I did compile them. Note that your analysis
> appeared correct for all cases but ocfs2, which does use get_sb_bdev()
> and hence gets ->s_bdi assigned.
> 
> You can see them here, I'll post the series soon:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-linus
> 
> The first patch is a helper addition, the rest are per-fs fixups.

Do you want to include Jörn's addition of same to get_sb_mtd_set(), with
my Acked-By: David Woodhouse <David.Woodhouse@intel.com> ? 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

