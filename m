Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab2CNHvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:51:15 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54311
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758399Ab2CNHvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:51:13 -0400
Date: Wed, 14 Mar 2012 03:51:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] radix-tree: iterating general cleanup
Message-ID: <20120314075109.GA32717@infradead.org>
References: <20120207074905.29797.60353.stgit@zurg>
 <20120314073629.GA17016@infradead.org>
 <4F604D81.1060607@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F604D81.1060607@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:49:21AM +0400, Konstantin Khlebnikov wrote:
> Christoph Hellwig wrote:
> >Any updates on this series?
> 
> I had sent "[PATCH v2 0/3] radix-tree: general iterator" February 10, there is no more updates after that.
> I just checked v2 on top "next-20120314" -- looks like all ok.

this was more a question to the MM maintainers if this is getting
merged or if there were any further comments.

We'd really like to have this interface to simplify some code in XFS.
