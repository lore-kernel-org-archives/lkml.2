Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2FQVBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:01:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60654
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757655Ab2FQVBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:01:07 -0400
Date: Sun, 17 Jun 2012 17:01:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] hfsplus: Fix bless ioctl when used with hardlinks
Message-ID: <20120617210104.GA22818@infradead.org>
References: <1334609838-14831-1-git-send-email-mjg@redhat.com>
 <CA+5PVA5EAi7O3nLGdxxJo5Hrp3+NJeBuW_Rtxj0QowpUKeGnYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5EAi7O3nLGdxxJo5Hrp3+NJeBuW_Rtxj0QowpUKeGnYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 07:57:24AM -0400, Josh Boyer wrote:
> On Mon, Apr 16, 2012 at 4:57 PM, Matthew Garrett <mjg@redhat.com> wrote:
> > HFS+ doesn't really implement hard links - instead, hardlinks are indicated
> > by a magic file type which refers to an indirect node in a hidden
> > directory. The spec indicates that stat() should return the inode number
> > of the indirect node, but it turns out that this doesn't satisfy the
> > firmware when it's looking for a bootloader - it wants the catalog ID of
> > the hardlink file instead. Fix up this case.
> >
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > ---
> >
> > V2 cleans up the casting.
> 
> Did this patch get dropped on the floor?  It's been almost 2 months
> since it was submitted.

It just got missed, sorry.  I'll send it along ASAP.

