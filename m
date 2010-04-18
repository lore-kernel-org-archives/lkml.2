Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0DRAPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 20:15:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab0DRAPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 20:15:18 -0400
Date: Sat, 17 Apr 2010 20:15:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100418001514.GA26575@infradead.org>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com> <1271118255-21070-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271118255-21070-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance we can still get this into 2.6.34?  It's really needed to fix
a regression in XFS that would be hard to impossible to work around
inside the fs.  While it touches quite a few places the changes are
trivial and well understood.

