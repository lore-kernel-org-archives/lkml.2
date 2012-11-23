Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2KWIOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:14:31 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36364
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734Ab2KWIOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:14:30 -0500
Date: Fri, 23 Nov 2012 03:14:27 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v4 01/31] iov_iter: move into its own file
Message-ID: <20121123081427.GA10731@infradead.org>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
 <1353537671-26284-2-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353537671-26284-2-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:40:41PM -0600, Dave Kleikamp wrote:
> From: Zach Brown <zab@zabbo.net>
> 
> This moves the iov_iter functions in to their own file.  We're going to
> be working on them in upcoming patches.  They become sufficiently large,
> and remain self-contained, to justify seperating them from the rest of
> the huge mm/filemap.c.
> 
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Cc: Zach Brown <zab@zabbo.net>

Is this mm or fs code?  I'd be tempted to have the file in fs/.

