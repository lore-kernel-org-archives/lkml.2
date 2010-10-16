Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0JPQ23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:28:29 -0400
Received: from canuck.infradead.org ([134.117.69.58]:37840 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0JPQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:28:28 -0400
Date: Sat, 16 Oct 2010 12:28:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] kernel: add bl_list
Message-ID: <20101016162825.GA20086@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-2-git-send-email-david@fromorbit.com>
 <20100929215208.b0206460.akpm@linux-foundation.org>
 <20101016075521.GJ19147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016075521.GJ19147@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 06:55:21PM +1100, Nick Piggin wrote:
> > > +static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
> > > +{
> > > +	h->next = NULL;
> > > +	h->pprev = NULL;
> > > +}
> > 
> > No need to shout.
> 
> Just following the rest of the lists.

Yes, just following hlist is logical.  Anyway, I don't think this
or the poisoning value really matter very much.

