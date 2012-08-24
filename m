Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab2HXMri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:47:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40843 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080Ab2HXMre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:47:34 -0400
Date: Fri, 24 Aug 2012 05:46:59 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com
Subject: Re: [PATCH v6 00/13] Block cleanups
Message-ID: <20120824124659.GA12977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <20120823180041.GK12232@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823180041.GK12232@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 02:00:41PM -0400, Vivek Goyal wrote:
> On Wed, Aug 22, 2012 at 10:03:57AM -0700, Kent Overstreet wrote:
> 
> [..]
> > Kent Overstreet (13):
> >   block: Generalized bio pool freeing
> >   dm: Use bioset's front_pad for dm_rq_clone_bio_info
> >   block: Add bio_reset()
> >   pktcdvd: Switch to bio_kmalloc()
> >   block: Kill bi_destructor
> >   block: Consolidate bio_alloc_bioset(), bio_kmalloc()
> 
> This patch series says "Block Cleanups" in the subject. I think that
> it can be divided in two parts. First part seems to be cleanup where
> we get rid of ->bi_destructor and merge kmalloc() and allocation 
> from bio_set.
> 
> Second part seems to be more of enhancing bio splitting functionality
> and not necessarily a cleanup. So may be breaking this series in two
> parts makes sense. First part is cleanup and second part is enhanced
> bio splitting capabilities of block layer.

Yeah, that's a good idea - will do.
