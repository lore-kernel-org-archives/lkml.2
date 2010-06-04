Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0FDHwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:52:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0FDHwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:52:24 -0400
Date: Fri, 4 Jun 2010 03:52:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-ID: <20100604075223.GB7317@infradead.org>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com> <1275609328-12514-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275609328-12514-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if there still are potential livelocks after this it's a big
step in the right direction, so


Reviewed-by: Christoph Hellwig <hch@lst.de>

