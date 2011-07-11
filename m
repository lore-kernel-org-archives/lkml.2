Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab1GKPY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:24:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48535
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757922Ab1GKPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:24:55 -0400
Date: Mon, 11 Jul 2011 11:24:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
        autofs@linux.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] VFS: Fix automount for negative autofs dentries
Message-ID: <20110711152447.GA20501@infradead.org>
References: <20110711134147.GA6853@infradead.org>
 <20110711132057.14641.36229.stgit@warthog.procyon.org.uk>
 <16882.1310393621@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16882.1310393621@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 03:13:41PM +0100, David Howells wrote:
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > would do the same.
> 
> But is much less obvious.  The LOOKUP_FOLLOW flag is the primary reason for
> this statement.  The rest are subordinate and would be wholly irrelevant if
> LOOKUP_FOLLOW was to be removed from the list.

Then keep the LOOKUP_FOLLOW semi-separate as in the original code.
But there's absolutely no reason for the goto spaghetti.

