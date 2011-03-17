Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1CQORB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:17:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1CQOQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:16:59 -0400
Date: Thu, 17 Mar 2011 10:16:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: remove warning about invalid s_maxbytes values
Message-ID: <20110317141656.GA28319@infradead.org>
References: <1300371163-23923-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300371163-23923-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 10:12:43AM -0400, Jeff Layton wrote:
> This warning should have been removed in 2.6.34. We missed that by a
> few releases, so we should be OK to remove this now.

Why can't we just kee it?

