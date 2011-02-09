Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab1BIEwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 23:52:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1BIEwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 23:52:22 -0500
Date: Tue, 8 Feb 2011 23:52:21 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Charles Manning <cdhmanning@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ryan@bluewatersys.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110209045221.GB29650@infradead.org>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 04:25:58PM +1300, Charles Manning wrote:
> Comments/feedback welcome, but I'm hopefully getting pretty close to
> acceptance :-).

It's not anywhere near ready as long as you insist keeping that silly
Linux glue code.  Also make sure it passes the xfstests QA suite
(http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=summary), which
might need a bit work to be made run depending on how quirky your
mkfs/fsck tools are.

