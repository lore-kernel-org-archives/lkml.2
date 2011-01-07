Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1AGHZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 02:25:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1AGHZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 02:25:10 -0500
Date: Fri, 7 Jan 2011 02:25:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110107072510.GB32308@infradead.org>
References: <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104083132.GA4485@amd>
 <20110104092541.GC2760@infradead.org>
 <20110104095231.GB4812@amd>
 <20110106204911.GB2872@infradead.org>
 <20110107044836.GB4552@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107044836.GB4552@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 03:48:36PM +1100, Nick Piggin wrote:
> OK, I don't exactly see why a sync_inode with appropriate flag could
> not solve that problem. I'll take a bit more look through nfs and
> xfs. Thanks...

We could also overload all inode operations into a single ioctl like
method, but that doesn't make it a good design.
