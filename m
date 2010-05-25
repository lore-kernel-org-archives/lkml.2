Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab0EYJV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:21:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab0EYJVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:21:55 -0400
Date: Tue, 25 May 2010 05:21:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Cluster-devel] [PATCH 1/3] GFS2: Rework reclaiming unlinked
	dinodes
Message-ID: <20100525092155.GA9575@infradead.org>
References: <1274775689-4689-1-git-send-email-swhiteho@redhat.com> <1274775689-4689-2-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274775689-4689-2-git-send-email-swhiteho@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 09:21:27AM +0100, Steven Whitehouse wrote:
> From: Bob Peterson <rpeterso@redhat.com>
> 
> The previous patch I wrote for reclaiming unlinked dinodes
> had some shortcomings and did not prevent all hangs.
> This version is much cleaner and more logical, and has
> passed very difficult testing.  Sorry for the churn.

It would be much more helpful to have a commit message that describes
what is changed and why.  The above one won't tell anyting to someone
reading through the commit log later on.

